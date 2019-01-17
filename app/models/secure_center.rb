class SecureCenter < ApplicationRecord
  serialize :payment_score
  serialize :collection_ratio_days
  has_paper_trail
  def supplier_connected
    supplier_paid
  end


  ###TO be removed after updating website secure center.
  def given_credit_limit
    credit_limit = CreditLimit.find_by(buyer_id: self.buyer_id, seller_id: self.seller_id)
    credit_limit.present? ? credit_limit.credit_limit : 0
  end

  def given_market_limit
    credit_limit = CreditLimit.find_by(buyer_id: self.buyer_id, seller_id: self.seller_id)
    credit_limit.present? ? credit_limit.market_limit : 0
  end

  def given_overdue_limit
    days_limit = DaysLimit.find_by(buyer_id: self.buyer_id, seller_id: self.seller_id)
    days_limit.present? ? days_limit.days_limit : 30
  end

  def supplier_unpaid
    company = Company.find_by(self.buyer_id)
    company.supplier_unpaid
  end

  def market_limit
    CreditLimit.where(seller_id: self.seller_id, buyer_id: self.buyer_id).first.market_limit.to_i rescue 0
  end
  def buyer_days_limit
    company = Company.find_by(self.buyer_id)
    count = 0
    transactions = company.buyer_transactions.where(seller_id: self.seller_id)
    transactions.each do |t|
      if t.due_date.present? && (Date.current - t.due_date.to_date).to_i > 30
        count = count + 1
      end
    end
    return count
  end

  def late_days
    company = Company.find_by(self.buyer_id)
    transaction = company.buyer_transactions.where("due_date < ? AND paid = ?", Date.current, false).order(:due_date).first
    if transaction.present? && transaction.due_date.present?
      late_days = (Date.current.to_date - transaction.due_date.to_date).to_i
    else
      late_days = 0
    end
    late_days.present? ? late_days.abs : 0
  end

  rails_admin do
    configure :versions do
      label "Versions"
    end
  end

end
