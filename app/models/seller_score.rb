class SellerScore < ApplicationRecord
  belongs_to :company

  #Calculate Seller Scores for each "seller" company
  def self.calculate_scores
=begin
    companies = Company.joins(:seller_transactions)
    if companies.count.positive?
      puts "$$$$$$$$$$$$$"
      puts companies.inspect
      puts "$$$$$$$$$$$$$$$$$$"
    else
      puts "$$$$$$$$$$$$$"
      puts "companies.inspect"
      puts "$$$$$$$$$$$$$$$$$$"
    end
=end

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

  def calculate_seller_network(company_id)
    return 0
  end

  def calculate_due_date(company_id)
    return 0
  end

  def calculate_credit_used(company_id)
    return 0
  end

  def calculate_total(company_id)
    return 0
  end

end
