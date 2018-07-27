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

        buyer_score = BuyerScore.new
        buyer_score.company_id = company.id
        buyer_score.late_payment = self.calculate_late_payment(company.id)
        buyer_score.current_risk = self.calculate_current_risk(company.id)
        buyer_score.network_diversity = self.calculate_network_diversity(company.id)
        buyer_score.due_date = self.calculate_due_date(company.id)
        buyer_score.credit_used = self.calculate_credit_used(company.id)
        buyer_score.count_of_credit_given = self.calculate_credit_given(company.id)
        buyer_score.actual = true
        buyer_score.created_at = Time.now
        buyer_score.updated_at = Time.now

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
      market_buyer_scores = MarketBuyerScore.get_scores
      companies.each do |company|
        buyer_score = self.get_score(company.id)
        unless buyer_score.nil?
          buyer_score.update(
              buyer_network: self.calculate_buyer_network(company.id),
              total: self.calculate_total(buyer_score, market_buyer_scores),
              updated_at: Time.now
          )
        end

      end
      #update average Market Buyer Scores
      MarketBuyerScore.calculate_scores(false )
    end

  end

  def self.get_score(company_id)
    return BuyerScore.where("company_id = ? AND actual = ?", company_id, true).order(:created_at).last
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

  def self.calculate_buyer_network(company_id)
    return 4
  end

  def self.calculate_due_date(company_id)
    return 5
  end

  def self.calculate_credit_used(company_id)
    return 6
  end

  def self.calculate_credit_given(company_id)
    return 7
  end

  def self.calculate_total(buyer_score, avg_scores, exclude_fields = [])
    #add fields to exclude always
    exclude_fields.push( "id", "company_id", "actual", "created_at", "updated_at")
    #init variables
    fields_count = 0
    fields_sum = 0
    total = 0

    #calculate sum of User Scores
    buyer_score.attributes.each_pair do |name, value|
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
