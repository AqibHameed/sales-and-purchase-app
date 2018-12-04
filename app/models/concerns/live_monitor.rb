module LiveMonitor

  extend ActiveSupport::Concern

  def secure_center
    if self.class.name == "CompaniesGroup"
      buyer_ids = company_id
    else
      buyer_ids = buyer_id
    end
    #secure_center = SecureCenter.find_by("seller_id = ? AND buyer_id = ? ", seller_id, buyer_ids)

   # unless secure_center.present?

        current_company = Company.where(id: seller_id).first
        if current_company
            company = Company.where(id: buyer_ids).first
            if company.present?
              data = get_secure_center_record(company, current_company)
              data.merge!(buyer_id: buyer_ids)
              data.merge!(seller_id: current_company.id)
              secure_center = SecureCenter.new(data)
              secure_center.save
            end
        end
   # end
  end

  def   get_secure_center_data(company, current_company)
    company_transactions = company.buyer_transactions

    if company_transactions.present?
      company_transactions_with_current_seller = company_transactions.where(seller_id: current_company.id)
      transactions = company_transactions.joins(:partial_payment).order('updated_at ASC')
      last_bought_on = company_transactions.where.not(paid: false).order('updated_at ASC').last

      date = transactions.present? ? transactions.last.partial_payment.last.updated_at :  nil

      transaction = company.buyer_transactions.where("due_date < ? AND paid = ?", Date.current, false).order(:due_date).first
      if transaction.present? && transaction.due_date.present?
        late_days = (Date.current.to_date - transaction.due_date.to_date).to_i
      else
        late_days = 0
      end
    end

    @group = CompaniesGroup.where("company_id like '%#{company.id}%'").where(seller_id: current_company.id).first
    @credit_limit = CreditLimit.find_by(buyer_id: company.id, seller_id: current_company.id)
    @days_limit = DaysLimit.find_by(buyer_id: company.id, seller_id: current_company.id)

    {
        invoices_overdue:  company_transactions.where("due_date < ? AND paid = ?", Date.current, false).count,
        paid_date: date,
        late_days: late_days.present? ? late_days.abs : 0,
        buyer_days_limit: buyer_days_limit(company, current_company),
        market_limit: get_market_limit_from_credit_limit_table(company, current_company).to_i,
        supplier_paid: company.supplier_paid,
        supplier_unpaid: company.supplier_unpaid,
        outstandings: company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("paid = ?", false).sum(:remaining_amount) : 0,
        overdue_amount: company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("due_date < ? AND paid = ?", Date.current, false).sum(:remaining_amount) : 0,
        given_credit_limit: @credit_limit.present? ? @credit_limit.credit_limit : 0,
        given_market_limit: @credit_limit.present? ? @credit_limit.market_limit : 0,
        given_overdue_limit: @days_limit.present? ? @days_limit.days_limit : 30,
        last_bought_on: last_bought_on.present? ? last_bought_on.updated_at : nil
    }
  end


  def buyer_days_limit(company, current_company)
    count = 0
    transactions = company.buyer_transactions.where(seller_id: current_company.id)
    transactions.each do |t|
      if t.due_date.present? && (Date.current - t.due_date.to_date).to_i > 30
        count = count + 1
      end
    end
    return count
  end

  def get_market_limit_from_credit_limit_table(buyer, supplier)
    CreditLimit.where(seller_id: supplier.id, buyer_id: buyer.id).first.market_limit.to_i rescue 0
  end

  def  get_secure_center_record(company, current_company)
    company_transactions = company.buyer_transactions

    if company_transactions.present?
      company_transactions_with_current_seller = company_transactions.where(seller_id: current_company.id)
      transactions = company_transactions.joins(:partial_payment).order('updated_at ASC')
      last_bought_on = company_transactions.order('created_at ASC').last

      date = transactions.present? ? transactions.last.partial_payment.last.updated_at :  nil
      transaction = company.buyer_transactions.where("due_date < ? AND paid = ?", Date.current, false).order(:due_date).first
      if transaction.present? && transaction.due_date.present?
        late_days = (Date.current.to_date - transaction.due_date.to_date).to_i
      else
        late_days = 0
      end
    end

    #@group = CompaniesGroup.where("company_id like '%#{company.id}%'").where(seller_id: current_company.id).first
    credit_limit = CreditLimit.find_by(buyer_id: company.id, seller_id: current_company.id)
    days_limit = DaysLimit.find_by(buyer_id: company.id, seller_id: current_company.id)
    {
        invoices_overdue:  company_transactions.where("due_date < ? AND paid = ? AND remaining_amount > 2000", Date.current, false).count,
        paid_date: date,
        late_days: late_days.present? ? late_days.abs : 0,
        buyer_days_limit: buyer_days_limit(company, current_company),
        market_limit: get_market_limit_from_credit_limit_table(company, current_company).to_i,
        supplier_paid: company.supplier_paid,
        supplier_unpaid: company.supplier_unpaid,
        outstandings: company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("paid = ?", false).sum(:remaining_amount).round(2) : 0.0,
        overdue_amount: company_transactions_with_current_seller.present? ? company_transactions_with_current_seller.where("due_date < ? AND paid = ?", Date.current, false).sum(:remaining_amount).round(2) : 0,
        given_credit_limit: credit_limit.present? ? credit_limit.credit_limit : 0,
        given_market_limit: credit_limit.present? ? credit_limit.market_limit : 0,
        given_overdue_limit: days_limit.present? ? days_limit.days_limit : 30,
        last_bought_on: last_bought_on.present? ? last_bought_on.updated_at : nil,
        buyer_percentage: company.buyer_transaction_percentage,
        system_percentage: company.system_transaction_percentage
    }
  end

end
