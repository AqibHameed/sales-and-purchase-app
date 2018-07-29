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
        seller_score = SellerScore.new
        seller_score.company_id = company.id
        seller_score.late_payment = self.calculate_late_payment(company.id)
        seller_score.current_risk = self.calculate_current_risk(company.id)
        seller_score.network_diversity = self.calculate_network_diversity(company.id)
        seller_score.due_date = self.calculate_due_date(company.id)
        seller_score.credit_used = self.calculate_credit_used(company.id)
        seller_score.actual = true
        seller_score.created_at = Time.now
        seller_score.updated_at = Time.now

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
      market_seller_scores = MarketSellerScore.get_scores
      companies.each do |company|
        seller_score = self.get_score(company.id)
        unless seller_score.nil?
          seller_score.update(
              seller_network: self.calculate_seller_network(company.id),
              total: self.calculate_total(seller_score, market_seller_scores),
              updated_at: Time.now
          )
        end

      end
      #update average Market Buyer Scores
      MarketSellerScore.calculate_scores(false )
    end
  end

  def self.get_score(company_id)
    return SellerScore.where("company_id = ? AND actual = ?", company_id, true).order(:created_at).last
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
               company_id, Date.today, false, true
    ).first

    return (result.current_risk.to_f).round(2)
  end

  def self.calculate_network_diversity(company_id)
    return 3
  end

  def self.calculate_seller_network(company_id)
    result = 0
    buyers = Transaction.select("distinct buyer_id").where("seller_id = ? and buyer_confirmed = ?", company_id, true).all
    if buyers.count.positive?
      total_amount = 0
      total_multiple_amount = 0
      buyers.each do |t|
        total_amount += Transaction.where("buyer_id = ? and seller_id = ? and buyer_confirmed = ?", t.buyer_id, company_id, true).sum(:total_amount)
        total_multiple_amount += BuyerScore.get_score(t.seller_id).total * total_amount
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
    exclude_fields.push("id", "company_id", "actual", "created_at", "updated_at")
    #init variables
    fields_count = 0
    fields_sum = 0
    total = 0

    #calculate sum of User Scores
    seller_score.attributes.each_pair do |name, value|

      unless exclude_fields.include? name
        avg_value = avg_scores.attributes[name]
        if !avg_value.nil? && avg_value.positive?
          fields_sum += (value/avg_value).round(2)
          fields_count += 1
        end
      end
    end

    if fields_count.positive?
      total = (fields_sum/fields_count).round(2)
    end

    return total
  end

end
