class BuyerScore < ApplicationRecord
  belongs_to :company

  #Calculate Buyer Scores for each "buyer" company
  def self.calculate_scores
    companies = Company.joins(:buyer_transactions).uniq
    if companies.count.positive?
      #clear "actual" flag
      BuyerScore.update_all(actual: false)

      #Calculate BuyerScores without "buyer network"
      companies.each do |company|
        BuyerScore.create(
            company_id: company.id,
            actual: true,
            late_payment: self.calculate_late_payment(company.id),
            current_risk: self.calculate_current_risk(company.id),
            network_diversity: self.calculate_network_diversity(company.id),
            due_date: self.calculate_due_date(company.id),
            credit_used: self.calculate_credit_used(company.id),
            count_of_credit_given: self.calculate_credit_given(company.id),
            created_at: Time.now,
            updated_at: Time.now
        )
      end
      #update average Market Buyer Scores
      #MarketBuyerScore.calculate_scores
    end
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

  def self.calculate_total(company_id)
    return 8
  end
end
