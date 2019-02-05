class BuyerScore < ApplicationRecord
  belongs_to :company

  #Calculate Buyer Scores for each "buyer" company
  def self.calculate_scores_first_step
    companies = Company.joins(:buyer_transactions).uniq
    if companies.count.positive?
      #clear "actual" flag
      BuyerScore.update_all(actual: false)

      #Calculate BuyerScores without "buyer network"
      companies.each do |company|

        buyer_score = BuyerScore.find_or_initialize_by(company_id: company.id)
        buyer_score.company_id = company.id
        buyer_score.late_payment = self.calculate_late_payment(company.id)
        buyer_score.current_risk = self.calculate_current_risk(company.id)
        buyer_score.network_diversity = self.calculate_network_diversity(company.id)
        buyer_score.due_date = self.calculate_due_date(company.id)
        buyer_score.credit_used = self.calculate_credit_used(company.id)
        buyer_score.count_of_credit_given = self.calculate_credit_given(company.id)
        buyer_score.actual = true


        buyer_score.save
      end
      #update average Market Buyer Scores
      market_buyer_scores = MarketBuyerScore.calculate_scores(true)
      #calculate totals
      companies.each do |company|
        buyer_score = self.get_score(company.id)
        unless buyer_score.nil?
          total = self.calculate_total(buyer_score, market_buyer_scores, ['buyer_network'])
          buyer_score.update(total: total, updated_at: Time.now)
        end
      end

    end
  end

  def self.calculate_scores_second_step
    companies = Company.joins(:buyer_transactions).uniq
    if companies.count.positive?
      companies.each do |company|
        buyer_score = self.get_score(company.id)
        unless buyer_score.nil?
          buyer_score.update(
              buyer_network: self.calculate_buyer_network(company.id),
              updated_at: Time.now
          )
        end
      end
      #update average Market Buyer Scores
      market_buyer_scores = MarketBuyerScore.calculate_scores(false )
      companies.each do |company|
        buyer_score = self.get_score(company.id)
        unless buyer_score.nil?
          buyer_score.update(
              total: self.calculate_total(buyer_score, market_buyer_scores)
          )
        end
        update_score_comparison(buyer_score, market_buyer_scores)
      end
    end

  end

  def self.update_score_comparison(buyer_score, market_buyer_scores)
    late_payment = ApplicationHelper.safe_divide_float(buyer_score.late_payment, market_buyer_scores.late_payment)
    current_risk = ApplicationHelper.safe_divide_float(buyer_score.current_risk, market_buyer_scores.current_risk)
    network_diversity = ApplicationHelper.safe_divide_float(buyer_score.network_diversity, market_buyer_scores.network_diversity)
    buyer_network = ApplicationHelper.safe_divide_float(buyer_score.buyer_network, market_buyer_scores.buyer_network)
    due_date = ApplicationHelper.safe_divide_float(buyer_score.due_date, market_buyer_scores.due_date)
    credit_used = ApplicationHelper.safe_divide_float(buyer_score.credit_used, market_buyer_scores.credit_used)
    count_of_credit_given = ApplicationHelper.safe_divide_float(buyer_score.count_of_credit_given, market_buyer_scores.count_of_credit_given)
    buyer_score.update_attributes(late_payment_comparison: late_payment, current_risk_comparison: current_risk, network_diversity_comparison: network_diversity,
                                  buyer_network_comparison: buyer_network, due_date_comparison: due_date, credit_used_comparison: credit_used,
                                  count_of_credit_given_comparison: count_of_credit_given)
  end

  def self.get_score(company_id)
    scores = BuyerScore.where("company_id = ? AND actual = ?", company_id, true).order(:created_at).last
    if scores.nil?
      scores = BuyerScore.new
      scores.company_id = company_id
      scores.late_payment = 0
      scores.current_risk = 0
      scores.network_diversity = 0
      scores.buyer_network = 0
      scores.due_date = 0
      scores.credit_used = 0
      scores.count_of_credit_given = 0
      scores.actual = true
      scores.save
    end
    return scores
  end

  #Calculate each score separately
  def self.calculate_late_payment(company_id)
    result = 0

    paid_transactions = Transaction.joins(:partial_payment).where("buyer_id = ? and paid = ? and buyer_confirmed = ?", company_id, true, true).uniq
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
        buyer_id = ? AND
        due_date < ? AND
        paid = ? AND
        buyer_confirmed = ? ",
               company_id, Date.current, false, true
    ).first

    return (result.current_risk.to_f).round(2)
  end

  def self.calculate_network_diversity(company_id)
    result = 0
    sellers = Transaction.select("distinct seller_id").where("buyer_id = ? and buyer_confirmed = ?", company_id, true).all
    if sellers.count.positive?
      total_amount = Transaction.where("buyer_id = ? and buyer_confirmed = ?", company_id, true).sum(:total_amount).to_f
      sellers_percents = []
      sellers.each do |t|
        sellers_amount = Transaction.where("buyer_id = ? and seller_id = ? and buyer_confirmed = ?", company_id, t.seller_id, true).sum(:total_amount)
        percent = sellers_amount/total_amount
        sellers_percents.push(percent.to_f.round(2))
      end

      if sellers_percents.length > 1
        result = sellers_percents.sort.reverse.take((sellers_percents.length/2.to_f).ceil).sum
      else
        result = sellers_percents.sum
      end

      result = result*100
    end

    return result
  end

  def self.calculate_buyer_network(company_id)
    result = 0
    sellers = Transaction.select("distinct seller_id").where("buyer_id = ? and buyer_confirmed = ?", company_id, true).all
    if sellers.count.positive?
      total_amount = 0
      total_multiple_amount = 0
      sellers.each do |t|
        total_amount += Transaction.where("buyer_id = ? and seller_id = ? and buyer_confirmed = ?", company_id, t.seller_id, true).sum(:total_amount)
        total_multiple_amount += SellerScore.get_score(t.seller_id).total * total_amount
      end

      result = (total_multiple_amount / total_amount).to_f.round(2)

    end

    return result
  end

  def self.calculate_due_date(company_id)
    result = Transaction.select(
        "SUM(credit*total_amount)/SUM(total_amount) as due_date_score"
    ).where("
      buyer_id = ? AND
      buyer_confirmed = ? AND
      credit > ?",
        company_id, true, 0
    ).first

    return result.due_date_score.to_f.round(2)
  end

  def self.calculate_credit_used(company_id)
    result = 0
    sellers = Transaction.select("distinct seller_id").where("buyer_id = ? and buyer_confirmed = ?", company_id, true).all
    if sellers.count.positive?
      puts sellers.inspect
      sum_credit_used = 0
      sum_credit_given = 0
      sellers.each do |t|
        credit_used = Transaction.where(buyer_id: company_id, seller_id: t.seller_id, paid: false, buyer_confirmed: true).sum(:remaining_amount)
        if credit_used.positive?
          sum_credit_used += credit_used
          sum_credit_given += CreditLimit.where("buyer_id = ? and seller_id = ?", company_id, t.seller_id).sum(:credit_limit)
        end
      end
      if sum_credit_given.positive?
        result = (sum_credit_used / sum_credit_given).to_f.round(2)
      end
    end

    return result
  end

  def self.calculate_credit_given(company_id)
    return CreditLimit.where(buyer_id: company_id).count
  end

  def self.calculate_total(buyer_score, avg_scores, exclude_fields = [])
    #add fields to exclude always
    exclude_fields.push( "id", "company_id", "actual", "created_at", "updated_at", "total", "late_payment_rank",
                         "current_risk_rank", "network_diversity_rank", "buyer_network_rank", "due_date_rank","credit_used_rank",
                          "count_of_credit_given_rank", "late_payment_comparison", "current_risk_comparison", "network_diversity_comparison",
                           "buyer_network_comparison", "due_date_comparison", "credit_used_comparison", "count_of_credit_given_comparison")
    #init variables
    fields_count = 0
    fields_sum = 0
    total = 0

    #calculate sum of User Scores
    buyer_score.attributes.each_pair do |name, value|
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

  def self.update_percentile_rank
    companies_total_scores = []
    comapnies = Company.joins(:buyer_transactions).uniq
    comapnies.each do |company|
      companies_total_scores << company.get_buyer_score
    end
    late_payment = companies_total_scores.map{|company_score| company_score if company_score.late_payment_comparison != 0.0}.compact.sort_by(&:late_payment_comparison)
    current_risk = companies_total_scores.map{|company_score| company_score if company_score.current_risk_comparison != 0.0}.compact.sort_by(&:current_risk_comparison)
    network_diversity = companies_total_scores.map{|company_score| company_score if company_score.network_diversity_comparison != 0.0}.compact.sort_by(&:network_diversity_comparison)
    buyer_network = companies_total_scores.map{|company_score| company_score if company_score.buyer_network_comparison != 0.0}.compact.sort_by(&:buyer_network_comparison)
    due_date = companies_total_scores.map{|company_score| company_score if company_score.due_date_comparison != 0.0}.compact.sort_by(&:due_date_comparison)
    credit_used = companies_total_scores.map{|company_score| company_score if company_score.credit_used_comparison != 0.0}.compact.sort_by(&:credit_used_comparison)
    count_of_credit_given = companies_total_scores.map{|company_score| company_score if company_score.count_of_credit_given_comparison != 0.0}.compact.sort_by(&:count_of_credit_given_comparison).reverse

    total_companies = companies_total_scores.count
    ten_percent = ((total_companies / 100.to_f) * 10)
    twenty_percent = ((total_companies / 100.to_f) * 20)
    fourty_percent = ((total_companies / 100.to_f) * 40)
    hundred_percent = ((total_companies / 100.to_f) * 100)

    percentile_rank(late_payment, 'late_payment_rank', ten_percent, twenty_percent, fourty_percent, hundred_percent)
    percentile_rank(current_risk, 'current_risk_rank', ten_percent, twenty_percent, fourty_percent, hundred_percent)
    percentile_rank(network_diversity, 'network_diversity_rank', ten_percent, twenty_percent, fourty_percent, hundred_percent)
    percentile_rank(buyer_network, 'buyer_network_rank', ten_percent, twenty_percent, fourty_percent, hundred_percent)
    percentile_rank(due_date, 'due_date_rank', ten_percent, twenty_percent, fourty_percent, hundred_percent)
    percentile_rank(credit_used, 'credit_used_rank', ten_percent, twenty_percent, fourty_percent, hundred_percent)
    percentile_rank(count_of_credit_given, 'count_of_credit_given_rank', ten_percent, twenty_percent, fourty_percent, hundred_percent)
  end

  def self.percentile_rank(buyer_score_vs_market_score, rank_attribute, ten_percent, twenty_percent, fourty_percent, hundred_percent)
    rank = ''
    buyer_score_vs_market_score.each do |percentage|
      if buyer_score_vs_market_score.index(percentage) <= ten_percent
        rank = 10
      elsif buyer_score_vs_market_score.index(percentage) > ten_percent && buyer_score_vs_market_score.index(percentage) <= twenty_percent
        rank = 20
      elsif buyer_score_vs_market_score.index(percentage) > twenty_percent && buyer_score_vs_market_score.index(percentage) <= fourty_percent
        rank = 40
      elsif buyer_score_vs_market_score.index(percentage) > fourty_percent && buyer_score_vs_market_score.index(percentage) <= hundred_percent
        rank = nil
      end
      buyer_score = BuyerScore.find_by(company_id: percentage[:company_id])
      if buyer_score.present?
        buyer_score.update_attribute(rank_attribute, rank)
      end
    end
  end

end
