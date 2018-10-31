module LiveMonitor

  extend ActiveSupport::Concern

   def secure_center
    current_company = Company.where(id: seller_id).first
    if current_company
    	if self.class.name == "CompaniesGroup"
    		buyer_ids = company_id
    	else
    		buyer_ids = [buyer_id]
    	end
    	buyer_ids.each do |buyer_id|
	      company = Company.where(id: buyer_id).first
	      if company.present?
	      	if company.buyer_transactions.present?
		        if company.buyer_transactions.last.paid_date.nil?
		          date = company.buyer_transactions.last.partial_payment.order('created_at ASC').last.created_at if company.buyer_transactions.last.partial_payment.present?
		        else
		          date =  company.buyer_transactions.last.paid_date
		        end
		        transaction = company.buyer_transactions.where("due_date < ? AND paid = ?", Date.today, false).last
		        if transaction.present? && transaction.due_date.present?
		          late_days = (Date.today - transaction.due_date.to_date).to_i
		        else
		          late_days = 0
		        end
		      end
	        @group = CompaniesGroup.where("company_id like '%#{company.id}%'").where(seller_id: current_company.id).first
		    @credit_limit = CreditLimit.where(buyer_id: company.id, seller_id: current_company.id).first
		    @days_limit = DaysLimit.where(buyer_id: company.id, seller_id: current_company.id).first
		    company_transactions = company.buyer_transactions.where(seller_id: current_company.id)
		    data = {
		      invoices_overdue:  company_transactions.present? ? company_transactions.where("due_date < ? AND paid = ?", Date.today, false).count : 0,
		      paid_date: date, 
		      late_days: late_days.present? ? late_days.abs : 0,
		      buyer_days_limit: buyer_days_limit(company, current_company),
		      market_limit: get_market_limit_from_credit_limit_table(company, current_company).to_i,
		      supplier_connected: company.supplier_connected,
		      outstandings: company_transactions.present? ? company_transactions.where("due_date != ? AND paid = ?", Date.today, false).map(&:remaining_amount).compact.sum : 0,
		      overdue_amount: company_transactions.present? ? company_transactions.where("due_date < ? AND paid = ?", Date.today, false).map(&:remaining_amount).compact.sum : 0,
		      given_credit_limit: @credit_limit.present? ? @credit_limit.credit_limit : 0,
		      given_market_limit:  @group.present? ? @group.group_market_limit : (@credit_limit.present? ? @credit_limit.market_limit : 0),
		      given_overdue_limit: @group.present? ? @group.group_overdue_limit : (@days_limit.present? ? @days_limit.days_limit : 30),
		      last_bought_on: company_transactions.present? ? company_transactions.last.created_at : nil
		    }
        	data.merge!(buyer_id: buyer_id)
        	data.merge!(seller_id: current_company.id)
        	secure_center = SecureCenter.new(data)
                secure_center.save
	      end
      end
    end  
  end


  def buyer_days_limit(company, current_company)
    count = 0
    transactions = company.buyer_transactions.where(seller_id: current_company.id)
    transactions.each do |t|
      if t.due_date.present? && (Date.today - t.due_date.to_date).to_i > 30
        count = count + 1
      end
    end
    return count
  end

  def get_market_limit_from_credit_limit_table(buyer, supplier)
    CreditLimit.where(seller_id: supplier.id, buyer_id: buyer.id).first.market_limit.to_i rescue 0
  end

end
