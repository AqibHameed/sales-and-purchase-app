class BuyerScore < ApplicationRecord
  belongs_to :company

  #Calculate Buyer Scores for each "buyer" company
  def calculate_scores

  end

  #Calculate each score separately
  def calculate_late_payment(company_id)
    return 0
  end

  def calculate_current_risk(company_id)
    return 0
  end

  def calculate_network_diversity(company_id)
    return 0
  end

  def calculate_buyer_network(company_id)
    return 0
  end

  def calculate_due_date(company_id)
    return 0
  end

  def calculate_credit_used(company_id)
    return 0
  end

  def calculate_credit_given(company_id)
    return 0
  end

  def calculate_total(company_id)
    return 0
  end
end
