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
    over_due_count = 0
    in_zero = in_fiften = in_thirty = in_fourty_five = greater_fourty_five = 0
    company_transactions = company.buyer_transactions
    buyer_score = BuyerScore.get_score(current_company)
    market_score = MarketBuyerScore.get_scores
    transactions = Transaction.where('due_date < ? AND paid=? AND seller_id=? AND paid_at > due_date', DateTime.now, true, current_company.id)
    transactions.each do |transaction|
      late_days_payment = transaction.paid_at.to_date - transaction.due_date.to_date
      if late_days_payment <= 0.day
        in_zero += 1
      elsif late_days_payment > 0.day && late_days_payment <= 15.days
        in_fiften += 1
      elsif late_days_payment > 15.days && late_days_payment <= 30.days
        in_thirty += 1
      elsif late_days_payment > 30.days && late_days_payment <= 45.days
        in_fourty_five += 1
      elsif late_days_payment > 45.days
        greater_fourty_five += 1
      end
    end

    collection << [
        zer_percent: in_zero / transactions.size,
        less_fiften: in_fiften / transactions.size,
        less_thirty: in_fiften / transactions.size,
        less_fourty_five: in_fourty_five / transactions.size,
        greater_fourty_five: greater_fourty_five / transactions.size
    ]
    if company_transactions.present?
      company_transactions_with_current_seller = company_transactions.where(seller_id: current_company.id)
      transactions = company_transactions.joins(:partial_payment).order('updated_at ASC')
      last_bought_on = company_transactions.order('created_at ASC').last

      date = transactions.present? ? transactions.last.partial_payment.last.updated_at : nil
    end

    secure_center.invoices_overdue = company_transactions.where("due_date < ? AND paid = ? AND remaining_amount > 2000", Date.current, false).count
    secure_center.paid_date = date
    secure_center.supplier_paid = company.supplier_paid + company.buyer_connected
    secure_center.outstandings = company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("paid = ? AND buyer_confirmed = ?", false, true).sum(:remaining_amount).round(2) : 0.0
    secure_center.overdue_amount = company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("due_date < ? AND paid = ? AND buyer_confirmed = ?", Date.current, false, true).sum(:remaining_amount).round(2) : 0
    secure_center.last_bought_on = last_bought_on.present? ? last_bought_on.updated_at : nil
    secure_center.buyer_percentage = company.buyer_transaction_percentage
    secure_center.system_percentage = company.system_transaction_percentage
    secure_center.payment_score = buyer_score.late_payment
    secure_center.market_payment_score = market_score.late_payment
    secure_center.collection_ratio_days = collection
    secure_center.save

    secure_center

  end

end
