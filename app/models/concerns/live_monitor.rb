module LiveMonitor

  extend ActiveSupport::Concern

  def secure_center
    transaction = self
    seller =  transaction.seller
    buyer = transaction.buyer
    secure_center =  SecureCenter.find_by(seller_id: seller.id, buyer_id: buyer.id)
    secure_center =  secure_center.blank? ? SecureCenter.new(seller_id: seller.id, buyer_id: buyer.id) : secure_center
    @secure_center_record = create_or_update_secure_center(secure_center, buyer, seller)
    SecureCenterJob.perform_now
  end

  def create_or_update_secure_center(secure_center, company, current_company)
    company_transactions = company.buyer_transactions

    if company_transactions.present?
      company_transactions_with_current_seller = company_transactions.where(seller_id: current_company.id)
      transactions = company_transactions.joins(:partial_payment).order('updated_at ASC')
      last_bought_on = company_transactions.order('created_at ASC').last

      date = transactions.present? ? transactions.last.partial_payment.last.updated_at : nil
    end

    secure_center.invoices_overdue = company_transactions.where("due_date < ? AND paid = ? AND remaining_amount > 2000", Date.current, false).count
    secure_center.paid_date = date
    secure_center.supplier_paid = company.supplier_paid
    secure_center.outstandings = company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("paid = ? AND buyer_confirmed = ?", false, true).sum(:remaining_amount).round(2) : 0.0
    secure_center.overdue_amount = company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("due_date < ? AND paid = ? AND buyer_confirmed = ?", Date.current, false, true).sum(:remaining_amount).round(2) : 0
    secure_center.last_bought_on = last_bought_on.present? ? last_bought_on.updated_at : nil
    secure_center.buyer_percentage = company.buyer_transaction_percentage
    secure_center.system_percentage = company.system_transaction_percentage

    secure_center.save

    secure_center

  end

end
