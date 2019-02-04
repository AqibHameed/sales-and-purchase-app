class SellerScore < ApplicationRecord
  belongs_to :company

  #Calculate Seller Scores for each "seller" company
  def self.calculate_scores_first_step
    companies = Company.joins(:seller_transactions).uniq
    if companies.count.positive?
      #clear "actual" flag
      SellerScore.update_all(actual: false)

      #Calculate BuyerScores without "buyer network"
      companies.each do |company|
        seller_score = SellerScore.find_or_initialize_by(company_id: company.id)
        seller_score.company_id = company.id
        seller_score.late_payment = self.calculate_late_payment(company.id)
        seller_score.current_risk = self.calculate_current_risk(company.id)
        seller_score.network_diversity = self.calculate_network_diversity(company.id)
        seller_score.due_date = self.calculate_due_date(company.id)
        seller_score.credit_used = self.calculate_credit_used(company.id)
        seller_score.actual = true

        seller_score.save
      end
      #update average Market Buyer Scores
      market_seller_scores = MarketSellerScore.calculate_scores(true)
      #calculate totals
      companies.each do |company|
        seller_score = self.get_score(company.id)
        unless seller_score.nil?
          total = self.calculate_total(seller_score, market_seller_scores, ['seller_network'])
          seller_score.update(total: total, updated_at: Time.now)
        end
      end

    end
  end

  def self.calculate_scores_second_step
    companies = Company.joins(:seller_transactions).uniq
    if companies.count.positive?
      companies.each do |company|
        seller_score = self.get_score(company.id)
        unless seller_score.nil?
          seller_score.update(
              seller_network: self.calculate_seller_network(company.id),
              updated_at: Time.now
          )
        end
      end

      #update average Market Buyer Scores
      market_seller_scores = MarketSellerScore.calculate_scores(false )
      companies.each do |company|
        seller_score = self.get_score(company.id)
        unless seller_score.nil?
          seller_score.update(
              total: self.calculate_total(seller_score, market_seller_scores),
              updated_at: Time.now
          )
        end
        update_seller_score_comparison(seller_score, market_seller_scores)
      end
    end
  end

  def self.update_seller_score_comparison(seller_score, market_seller_scores)
    late_payment = ApplicationHelper.safe_divide_float(seller_score.late_payment, market_seller_scores.late_payment)
    current_risk = ApplicationHelper.safe_divide_float(seller_score.current_risk, market_seller_scores.current_risk)
    network_diversity = ApplicationHelper.safe_divide_float(seller_score.network_diversity, market_seller_scores.network_diversity)
    seller_network = ApplicationHelper.safe_divide_float(seller_score.seller_network, market_seller_scores.seller_network)
    due_date = ApplicationHelper.safe_divide_float(seller_score.due_date, market_seller_scores.due_date)
    credit_used = ApplicationHelper.safe_divide_float(seller_score.credit_used, market_seller_scores.credit_used)
    seller_score.update_attributes(seller_late_payment_comparison: late_payment, seller_current_risk_comparison: current_risk,
                                   seller_network_diversity_comparison: network_diversity, seller_network_comparison: seller_network,
                                   seller_due_date_comparison: due_date, seller_credit_used_comparison: credit_used)
  end


  def self.get_score(company_id)
    scores = SellerScore.where("company_id = ? AND actual = ?", company_id, true).order(:created_at).last
    if scores.nil?
      scores = SellerScore.new
      scores.company_id = company_id
      scores.late_payment = 0
      scores.current_risk = 0
      scores.network_diversity = 0
      scores.seller_network = 0
      scores.due_date = 0
      scores.credit_used = 0
      scores.actual = true
      scores.save
    end
    return scores
  end

  #Calculate each score separately
  def self.calculate_late_payment(company_id)
    result = 0

    paid_transactions = Transaction.joins(:partial_payment).where("seller_id = ? and paid = ? and buyer_confirmed = ?", company_id, true, true).uniq
    if paid_transactions.count.positive?
      sum_total_amount = 0
      sum_multiple_amount = 0

      paid_transactions.each do |t|
        payments = PartialPayment.where("transaction_id = ?", t.id).order('created_at DESC').first
        days_paid = (payments.created_at.to_date - t.created_at.to_date).to_i + 1
        if days_paid.positive?
          sum_total_amount += t.total_amount
          sum_multiple_amount += t.total_amount*days_paid
        end
      end
      result = (sum_multiple_amount / sum_total_amount).to_f.round(2)
    end

    return result
  end

  def self.calculate_current_risk(company_id)
    result = Transaction.select("
        SUM(remaining_amount*DATEDIFF(now(), due_date))/sum(remaining_amount) as current_risk
      ").where("
        seller_id = ? AND
        due_date < ? AND
        paid = ? AND
        buyer_confirmed = ? ",
               company_id, Date.current, false, true
    ).first

    return (result.current_risk.to_f).round(2)
  end

  def self.calculate_network_diversity(company_id)
    result = 0
    buyers = Transaction.select("distinct buyer_id").where("seller_id = ? and buyer_confirmed = ?", company_id, true).all
    if buyers.count.positive?
      total_amount = Transaction.where("seller_id = ? and buyer_confirmed = ?", company_id, true).sum(:total_amount).to_f
      buyers_percents = []
      buyers.each do |t|
        buyers_amount = Transaction.where("buyer_id = ? and seller_id = ? and buyer_confirmed = ?", company_id, t.buyer_id, true).sum(:total_amount)
        percent = buyers_amount/total_amount
        buyers_percents.push(percent.to_f.round(2))
      end

      if buyers_percents.length > 1
        result = buyers_percents.sort.reverse.take((buyers_percents.length/2.to_f).ceil).sum
      else
        result = buyers_percents.sum
      end

      result = result*100
    end

    return result
  end

  def self.calculate_seller_network(company_id)
    result = 0
    buyers = Transaction.select("distinct buyer_id").where("seller_id = ? and buyer_confirmed = ?", company_id, true).all
    if buyers.count.positive?
      total_amount = 0
      total_multiple_amount = 0
      buyers.each do |t|
        total_amount += Transaction.where("buyer_id = ? and seller_id = ? and buyer_confirmed = ?", t.buyer_id, company_id, true).sum(:total_amount)
        total_multiple_amount += BuyerScore.get_score(t.buyer_id).total * total_amount
      end
      result = (total_multiple_amount / total_amount).to_f.round(2)
    end

    return result
  end

  def self.calculate_due_date(company_id)
    result = Transaction.select(
        "SUM(credit*total_amount)/SUM(total_amount) as due_date_score"
    ).where("
      seller_id = ? AND
      buyer_confirmed = ? AND
      credit > ?",
            company_id, true, 0
    ).first

    return result.due_date_score.to_f.round(2)
  end

  def self.calculate_credit_used(company_id)
    result = 0
    buyers = Transaction.select("distinct buyer_id").where("seller_id = ? and buyer_confirmed = ?", company_id, true).all
    if buyers.count.positive?
      sum_credit_used = 0
      sum_credit_given = 0
      buyers.each do |t|
        credit_used = Transaction.where(buyer_id: t.buyer_id, seller_id: company_id, paid: false, buyer_confirmed: true).sum(:remaining_amount)
        if credit_used.positive?
          sum_credit_used += credit_used
          sum_credit_given += CreditLimit.where("buyer_id = ? and seller_id = ?", t.buyer_id, company_id).sum(:credit_limit)
        end
      end

      if sum_credit_given.positive?
        result = (sum_credit_used / sum_credit_given).to_f.round(2)
      end
    end

    return result
  end

  def self.calculate_total(seller_score, avg_scores, exclude_fields = [])
    #add fields to exclude always
    exclude_fields.push("id", "company_id", "actual", "created_at", "updated_at", "total", "seller_late_payment_rank",
                        "seller_current_risk_rank", "seller_network_diversity_rank", "seller_network_rank", "seller_due_date_rank",
                         "seller_credit_used_rank", "seller_late_payment_comparison", "seller_current_risk_comparison", "seller_network_diversity_comparison",
                         "seller_network_comparison", "seller_due_date_comparison", "seller_credit_used_comparison")
    #init variables
    fields_count = 0
    fields_sum = 0
    total = 0

    #calculate sum of User Scores
    seller_score.attributes.each_pair do |name, value|

      unless exclude_fields.include? name
        avg_value = avg_scores.attributes[name]
        if avg_value.positive?
          score = (value/avg_value).round(2)
          if score.positive?
            fields_sum += score
            fields_count += 1
          end
        end
      end
    end

    if fields_count.positive?
      total = (fields_sum/fields_count).round(2)
    end

    return total
  end

  def self.update_seller_percentile_rank
    companies_total_scores = []
    comapnies = Company.joins(:seller_transactions).uniq
    comapnies.each do |company|
      companies_total_scores << calculate_score(company)
    end
    late_payment = companies_total_scores.sort_by {|k| k[:late_payment]}
    current_risk = companies_total_scores.sort_by {|k| k[:current_risk]}
    network_diversity = companies_total_scores.sort_by {|k| k[:network_diversity]}
    seller_network = companies_total_scores.sort_by {|k| k[:seller_network]}
    due_date = companies_total_scores.sort_by {|k| k[:due_date]}
    credit_used = companies_total_scores.sort_by {|k| k[:credit_used]}

    total_companies = companies_total_scores.count
    twenty_percent = ((total_companies / 100.to_f) * 20)
    fifty_percent = ((total_companies / 100.to_f) * 50)
    seventy_percent = ((total_companies / 100.to_f) * 70)
    hundred_percent = ((total_companies / 100.to_f) * 100)

    percentile_rank(late_payment, 'seller_late_payment_rank', twenty_percent, fifty_percent, seventy_percent, hundred_percent)
    percentile_rank(current_risk, 'seller_current_risk_rank', twenty_percent, fifty_percent, seventy_percent, hundred_percent)
    percentile_rank(network_diversity, 'seller_network_diversity_rank', twenty_percent, fifty_percent, seventy_percent, hundred_percent)
    percentile_rank(seller_network, 'seller_network_rank', twenty_percent, fifty_percent, seventy_percent, hundred_percent)
    percentile_rank(due_date, 'seller_due_date_rank', twenty_percent, fifty_percent, seventy_percent, hundred_percent)
    percentile_rank(credit_used, 'seller_credit_used_rank', twenty_percent, fifty_percent, seventy_percent, hundred_percent)
  end

  def self.calculate_score(company)
    seller_score = company.get_seller_score

    late_payment = seller_score.seller_late_payment_comparison
    current_risk = seller_score.seller_current_risk_comparison
    network_diversity = seller_score.seller_network_diversity_comparison
    seller_network = seller_score.seller_network_comparison
    due_date = seller_score.seller_due_date_comparison
    credit_used = seller_score.seller_credit_used_comparison

    company_data = {
        company_id: company.id,
        late_payment: late_payment,
        current_risk: current_risk,
        network_diversity: network_diversity,
        seller_network: seller_network,
        due_date: due_date,
        credit_used: credit_used
    }
    return company_data
  end

  def self.percentile_rank(seller_score_vs_market_score, rank_attribute, twenty_percent, fifty_percent, seventy_percent, hundred_percent)
    rank = ''
    seller_score_vs_market_score.each do |percentage|
      if seller_score_vs_market_score.index(percentage) <= twenty_percent
        rank = 'top 20'
      elsif seller_score_vs_market_score.index(percentage) > twenty_percent && seller_score_vs_market_score.index(percentage) <= fifty_percent
        rank = '21 to 50'
      elsif seller_score_vs_market_score.index(percentage) > fifty_percent && seller_score_vs_market_score.index(percentage) <= seventy_percent
        rank = '51 to 70'
      elsif seller_score_vs_market_score.index(percentage) > seventy_percent && seller_score_vs_market_score.index(percentage) <= hundred_percent
        rank = '71 to 100'
      end
      seller_score = SellerScore.find_by(company_id: percentage[:company_id])
      if seller_score.present?
        seller_score.update_attribute(rank_attribute, rank)
      end
    end
  end

end
