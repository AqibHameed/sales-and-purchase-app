class SecureCenter < ApplicationRecord
  def supplier_connected
    supplier_paid
  end


  ###TO be removed after updating website secure center.
  def given_credit_limit
    credit_limit = CreditLimit.find_by(buyer_id: self.buyer_id, seller_id: self.seller_id)
    credit_limit.present? ? credit_limit.credit_limit : 0
  end

end
