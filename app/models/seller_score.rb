class SellerScore < ApplicationRecord
  belongs_to :company

  #Calculate Seller Scores for each "seller" company
  def self.calculate_scores_first_step
    companies = Company.joins(:buyer_transactions).uniq
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
    companies = Company.joins(:buyer_transactions).uniq
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
    return 1
  end

  def self.calculate_current_risk(company_id)
    return 2
  end

  def self.calculate_network_diversity(company_id)
    return 3
  end

  def self.calculate_seller_network(company_id)
    return 4
  end

  def self.calculate_due_date(company_id)
    return 5
  end

  def self.calculate_credit_used(company_id)
    return 6
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
