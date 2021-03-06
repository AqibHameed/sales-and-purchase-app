module ApplicationHelper
  def error_messages_for!(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
    :count => resource.errors.count,
    :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
      <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
      </div>
    HTML

    html.html_safe
  end

  def current_user
    current_customer || current_admin
  end

  def get_difference(bid, sell)

    logger.info "bid : #{bid}"
    logger.info "sell : #{sell}"
    if sell.nil? || sell.blank? || bid.nil? || bid.blank?
      return 'N/A'
    else
      if bid.to_f ==  sell.to_f
        return "<font color='green'>Won the Bid</font>"
      else
        return (100.0 - (bid / sell.to_f * 100)).round(2).to_s + ' %'
      end
    end
  end

  def get_sum(stones)
    sum = 0.0
    stones.each do |s|
      sum = sum + s.weight.round(2) rescue 0.0
    end
    return sum.round(2)
  end

  def get_winner_sum(winners)
    sum = 0.0
    winners.each do |s|
      sum = sum + s.selling_price.to_f.round(2) rescue 0.0
    end
    return sum.round(2)
  end

  def get_color(diff, desc)
    dif = diff[desc].abs rescue nil
    if (dif.nil?)
      return ''
    elsif dif.to_i <= 5
      return 'low'
    elsif dif.to_i > 5 and dif.to_i <= 15
      return 'mid'
    elsif dif.to_i > 15 and dif.to_i <= 25
      return 'high'
    else
      return 'vhigh'
    end
  end

  def get_description(parcel)
    if parcel.nil?
    else
      if parcel.description.nil? || parcel.description.blank?
        return "#{parcel.source} #{parcel.box}"
      else
        return "#{parcel.source} #{parcel.description}"
      end
    end
  end

  def get_remaining_limit(total_limit, assigned_limit)
    total_limit.to_f - assigned_limit.to_f
  end

  def get_sub_company_credit_limit(company)
    SubCompanyCreditLimit.find_by(sub_company_id: company).sum(:credit_limit) rescue nil
  end

  # def get_credit_purchase_percentage(count,total)
  #  return (count/total)*100
  # end

  def count_value(condition, total, option,customer)
    if condition == '0'
      transactions = Transaction.where('credit = ? and buyer_id =?', 0, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, Date.current, false, true, 0).sum(:total_amount)
      overdue = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, Date.current, false, true, 0).sum(:total_amount)
      complete = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, true, true, 0).sum(:total_amount)
    elsif condition =='less_30'
      transactions = Transaction.where('credit >= ? and credit <= ? and buyer_id =?',1, 30, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, Date.current, false, true, 1, 30).sum(:total_amount)
      overdue = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, Date.current, false, true, 1, 30).sum(:total_amount)
      complete = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, true, true, 1, 30).sum(:total_amount)
    elsif condition =='60'
      transactions = Transaction.where('credit > ? and credit <= ? and buyer_id =?', 30, 60, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.current, false, true, 30, 60).sum(:total_amount)
      overdue = Transaction.where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.current, false, true, 30, 60).sum(:total_amount)
      complete = Transaction.where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, true, true, 30, 60).sum(:total_amount)
    elsif condition =='90'
      transactions = Transaction.where('credit > ? and credit <= ? and buyer_id =?', 60, 90, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.current, false, true, 60, 90).sum(:total_amount)
      overdue = Transaction.where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.current, false, true, 60, 90).sum(:total_amount)
      complete = Transaction.where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, true, true, 60, 90).sum(:total_amount)
    else
      transactions = Transaction.where('credit > ? and buyer_id =?', 90,customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", customer.id, Date.current, false, true, 90).sum(:total_amount)
      overdue = Transaction.where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", customer.id, Date.current, false, true, 90).sum(:total_amount)
      complete = Transaction.where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", customer.id, true, true, 90).sum(:total_amount)
    end
    count_percent=((count/total.to_f)*100).to_i rescue 0
    pending_percent=((pending/total.to_f)*100).to_i rescue 0
    overdue_percent=((overdue/total.to_f)*100).to_i rescue 0
    complete_percent=((complete/total.to_f)*100).to_i rescue 0
    if option == 'count'
    return "#{count}(#{count_percent}%)"
    elsif option == 'pending'
      return "#{number_to_currency(pending)}(#{pending_percent}%)"
    elsif option == 'overdue'
      return "#{number_to_currency(overdue)}(#{overdue_percent}%)"
    elsif option == 'complete'
      return "#{number_to_currency(complete)}(#{complete_percent}%)"
    end
  end

  def sale_count_value(condition,total,option,company)
    if condition == '0'
      transactions = Transaction.where('credit = ? and seller_id =?', 0, company.id)
      count = transactions.count
      pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", company.id, Date.current, false, true, 0).sum(:total_amount)
      overdue = Transaction.where("seller_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", company.id, Date.current, false, true, 0).sum(:total_amount)
      complete = Transaction.where("seller_id = ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", company.id, true, true, 0).sum(:total_amount)
    elsif condition == 'less_30'
      transactions = Transaction.where('credit >= ? and credit <= ? and seller_id =?', 1, 30, company.id)
      count = transactions.count
      pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", company.id, Date.current, false, true, 1, 30).sum(:total_amount)
      overdue = Transaction.where("seller_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", company.id, Date.current, false, true, 1, 30).sum(:total_amount)
      complete = Transaction.where("seller_id = ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", company.id, true, true,1,30).sum(:total_amount)
    elsif condition == '60'
      transactions = Transaction.where('credit > ? and credit <= ? and seller_id =?', 30, 60, company.id)
      count = transactions.count
      pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", company.id, Date.current, false, true,30,60).sum(:total_amount)
      overdue = Transaction.where("seller_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", company.id, Date.current, false, true,30,60).sum(:total_amount)
      complete = Transaction.where("seller_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", company.id, true, true,30,60).sum(:total_amount)
    elsif condition == '90'
      transactions = Transaction.where('credit > ? and credit <= ? and seller_id =?', 60, 90, company.id)
      count = transactions.count
      pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ?  and credit <= ?", company.id, Date.current, false, true, 60, 90).sum(:total_amount)
      overdue = Transaction.where("seller_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", company.id, Date.current, false, true, 60, 90).sum(:total_amount)
      complete = Transaction.where("seller_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", company.id, true, true, 60, 90).sum(:total_amount)
    else
      transactions = Transaction.where('credit > ? and seller_id =?', 90, company.id)
      count = transactions.count
      pending = Transaction.where("seller_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit >?", company.id, Date.current, false, true, 90).sum(:total_amount)
      overdue = Transaction.where("seller_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", company.id, Date.current, false, true, 90).sum(:total_amount)
      complete = Transaction.where("seller_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", company.id, true, true, 90).sum(:total_amount)
    end
    count_percent = ((count/total.to_f)*100).to_i rescue 0
    pending_percent = ((pending/total.to_f)*100).to_i rescue 0
    overdue_percent = ((overdue/total.to_f)*100).to_i rescue 0
    complete_percent = ((complete/total.to_f)*100).to_i rescue 0
    if option == 'count'
    return "#{count}(#{count_percent}%)"
    elsif option == 'pending'
      return "#{number_to_currency(pending)}(#{pending_percent}%)"
    elsif option == 'overdue'
      return "#{number_to_currency(overdue)}(#{overdue_percent}%)"
    elsif option == 'complete'
      return "#{number_to_currency(complete)}(#{complete_percent}%)"
    end
  end

  def index_count page
    if page == 0
      return 0
    else
      (page - 1)*25
    end
  end

  def get_credit_limit(buyer, supplier)
    credit = credit_limit1(buyer.id, supplier.id)
    credit.present? ? credit.credit_limit : 0.0
  end

  def credit_limit1(buyer_id, supplier_id)
    CreditLimit.find_by(buyer_id: buyer_id, seller_id: supplier_id)
  end

  def get_days_limit(buyer, supplier)
    days_limit = DaysLimit.find_by(buyer_id: buyer.id, seller_id: supplier.id)
    days_limit.present? ? pluralize(days_limit.days_limit.to_i, 'day') : pluralize(30, 'day')
  end

  def get_available_credit_limit(buyer, supplier)
    credit_limit = CreditLimit.find_by(buyer_id: buyer.id, seller_id: supplier.id)

    total = credit_limit.present? ? credit_limit.credit_limit : 0.0
    used  =  get_used_credit_limit(buyer, supplier)
    available_credit_limit = total.to_f - used.to_f
    if available_credit_limit < 0
      available_credit_limit = 0.0
    end
    available_credit_limit
  end

  def get_market_limit(buyer, supplier)
    pendings = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.current, false, true)
    overdues = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.current, false, true)

    @amount = []
    pendings.each do |t|
      @amount << t.remaining_amount
    end
    overdues.each do |o|
      @amount << o.remaining_amount
    end
    pending_amt = @amount.sum
    number_with_precision(pending_amt, precision: 2)
  end

  def get_available_market_limit(buyer, credit_limit)
    total = credit_limit.market_limit
    used  =  get_used_market_limit(buyer)
    available_market_limit = total.to_f - used.to_f
    if available_market_limit < 0
       available_market_limit = 0.0
    end
    available_market_limit
  end


  def get_available_credit_limit_companies_group(buyer, supplier, companies_group)
    total = companies_group.credit_limit
    used  =  get_used_credit_limit(buyer, supplier)
    available_credit_limit = total.to_f - used.to_f
  end

  def get_available_market_limit_companies_group(buyer, companies_group)
    total = companies_group.group_market_limit
    used  =  get_used_market_limit(buyer)
    number_with_precision((total.to_f - used.to_f), precision: 2)
  end

  def get_credit_limit_companies_group(company_group)
    if company_group.credit_limit.nil? || company_group.credit_limit.blank?
      number_with_precision(0, precision: 2)
    else
      number_with_precision((company_group.credit_limit), precision: 2)
    end
  end

  def get_used_market_limit(buyer)
    Transaction.includes(:trading_parcel).where(buyer_id: [buyer], paid: false, buyer_confirmed: true).sum(:remaining_amount)
  end

  def get_market_limit_companies_group(company_group)
    if  company_group.group_market_limit.blank?
      number_with_precision(0, precision: 2)
    else
      number_with_precision((company_group.group_market_limit), precision: 2)
    end
  end


  def get_number_of_customers(supplier, amount,check)
    count = 0
    count1 = 0
    buyer_ids = CreditLimit.where(seller_id: supplier.id).map { |e| e.buyer_id  }
    buyers = Customer.where(id: buyer_ids)
    amount =  number_with_precision(amount, precision: 2)
    buyers.each do |b|
      available_credit = get_available_credit_limit(b, supplier)
      if  amount.to_f <= available_credit.to_f
        count += 1
      else
        count1 += 1
      end
    end
    if check == 'available'
      return count
    else
      return count1
    end
  end

  def get_count_no_credit(supplier)
    buyer_ids = CreditLimit.where(seller_id: supplier.id).map { |e| e.buyer_id  }
    buyers = Customer.where.not(id: buyer_ids)
    buyers.count-1
  end

  def supplier_connected(buyer,company)
    count = CreditLimit.where("buyer_id =? and seller_id !=?", buyer, company.id).count
  end

  def get_used_credit_limit(buyer, supplier)
    transactions = Transaction.where(buyer_id: buyer.id, seller_id: supplier.id, paid: false, buyer_confirmed: true).sum(:remaining_amount).to_f
  end

  # def get_used_market_limit(buyer)
  #   pendings = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.current, false, true)
  #   overdues = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.current, false, true)
  #
  #   @amount = []
  #   pendings.each do |t|
  #     @amount << t.remaining_amount
  #   end
  #   overdues.each do |o|
  #     @amount << o.remaining_amount
  #   end
  #   pending_amt = @amount.sum
  #   number_with_precision(pending_amt, precision: 2)
  # end

  def get_market_limit_from_credit_limit_table(buyer, supplier)
    CreditLimit.find_by(seller_id: supplier.id, buyer_id: buyer.id).market_limit.to_f rescue 0
  end

  def overall_credit_received(company)
    current_limit = CreditLimit.where(buyer_id: company.id).sum(:credit_limit)
    number_with_precision((current_limit), precision: 2)
  end

  def overall_market_limit_received(company)
    market_limit = CreditLimit.where(buyer_id: company.id).sum(:market_limit)
    number_with_precision((market_limit), precision: 2)
  end

  def overall_credit_spent(customer)
    transactions = Transaction.where(buyer_id: customer.id)
    @amount = []
    transactions.each do |t|
      @amount << t.remaining_amount
    end
    transaction_amt = @amount.sum
    number_with_precision(transaction_amt, precision: 2)
  end

  def credit_available_by_customer
    number_to_currency(overall_credit_received(current_customer).to_f - overall_credit_spent(current_customer).to_f)
  end

  def overall_credit_given(company)
    current_limit = CreditLimit.where(seller_id: company.id).sum(:credit_limit)
    number_with_precision((current_limit), precision: 2)
  end

  def overall_credit_spent_by_customer(company)
    transactions = Transaction.where(seller_id: company.id)
    @amount = []
    transactions.each do |t|
      @amount << t.remaining_amount
    end
    transaction_amt = @amount.sum
    number_with_precision(transaction_amt, precision: 2)
  end

  def credit_available(company)
    number_to_currency(overall_credit_given(company).to_f-overall_credit_spent_by_customer(company).to_f)
  end

  def get_status transaction
    if !transaction.buyer_confirmed
      'Awaiting Confirmation'
    elsif transaction.paid
      'Completed'
    else
      if transaction.due_date.nil? || transaction.due_date.blank?
        'N/A'
      elsif (transaction.due_date > Date.current) && (transaction.paid == false)
        'Pending Payment'
      elsif (transaction.due_date < Date.current) && (transaction.paid == false)
        'Overdue'
      end
    end
  end

  def grey_buy_btn(buyer, supplier)
    cl = CreditLimit.where(buyer_id: buyer, seller_id: supplier).first
    if cl.nil?
      return true
    else
      if (cl.credit_limit.nil? || cl.credit_limit == 0 || cl.credit_limit.blank?)
        return true
      else
        return false
      end
    end
  end

  def trading_parcel_list
    TradingParcel.where(customer_id: current_user.id).map { |e| [ get_description(e), e.id ] }
  end

  def customer_list verification_status=nil
    if verification_status
      Customer.unscoped.where.not(id: current_customer.id).order('first_name asc').map { |e| [(e.company.nil? || e.company.blank?) ? e.name : e.company.name, e.id, e.verified] }
    else
      Customer.unscoped.where.not(id: current_customer.id).order('first_name asc').map { |e| [(e.company.nil? || e.company.blank?) ? e.name : e.company.name, e.id] }
    end
  end

  def customer_list_options
    options = []
    customer_list(true).each do |customer|
      options << [customer[0], customer[1], {'data-icon' => customer[2] ? "http://35.154.233.15/images/verified.png" : "http://35.154.233.15/images/unverified.png" }]
    end
    options
  end

  def show_buyer_links
    if current_page?(trading_customers_path) || current_page?(transactions_customers_path) || current_page?(credit_customers_path)
      true
    else
      false
    end
  end

  def get_verified_text customer, supplier
    "Manual transactions are not protected by IDT Credit Protection. Please be aware the safest way to transact is ask your Buyer to purchase your parcel from you. Should you choose to go ahead with a manual transaction, you will not be notified for this transaction whether the buyer is already late on any payment. By ticking the box, you are agreeing to forego IDT Credit Protection."
  end

  def get_unverified_text customer, supplier
    if customer.has_overdue_transaction_of_30_days(supplier.id)
      status = "Restricted"
    else
      status = "Clear"
    end
    return "You are trading with an unregistered buyer. Kindly ask your buyer to register. For your protection, we are informing you regarding the unregistered buyer's credit status. This buyer's overdue status is: #{status}. Clear means this buyer does not have any overdues pending for 30 days or more. Restricted means this buyer has overdues of 30 days or more. Please be cautious when trading with Restricted buyers for your financial protection."
  end

  def view_proposal proposal
    "#{link_to('Click Here', Rails.application.routes.url_helpers.proposal_path(proposal))}"
  end

  def view_proposal_details proposal, current_customer
    ac = ActionController::Base.new()
    rendered_string = ac.render_to_string partial: 'proposals/proposal_details', locals: { proposal: proposal, current_customer: current_customer}
    return rendered_string
  end

  def view_request
    "#{link_to('Click Here', Rails.application.routes.url_helpers.requests_brokers_path)}"
  end

  def view_confirm_request
   "#{link_to('Click Here', Rails.application.routes.url_helpers.confirm_request_suppliers_path )}"
  end

  def view_limit_increase_accept parcel, buyer
    "#{link_to('Click Here', Rails.application.routes.url_helpers.accept_limit_increase_api_v1_trading_parcel_path(parcel, buyer_id: buyer.id) )}"
  end

  def view_limit_increase_reject parcel, buyer
    "#{link_to('Click Here', Rails.application.routes.url_helpers.reject_limit_increase_api_v1_trading_parcel_path(parcel, buyer_id: buyer.id) )}"
  end

  def check_round stones
    # YesNoBuyerInterest.where(stone_id: stones.map { |e| e.id }).empty
  end

  def parcel_list_for_demand(demand_list=nil)
    if demand_list.nil?
      []
    else
      demand_list.map { |e| e.description  }
    end
  end

  def supplier_list_for_demand(current_company, is_show)
    (current_company.try(:add_polished) && is_show)? DemandSupplier.all.map { |e| e.name } : DemandSupplier.where.not(name: 'POLISHED').map { |e| e.name }
  end

  def supplier_list_for_search
    DemandSupplier.where.not(name: 'POLISHED').map { |e| e.name }
  end

  def company_list_for_secure_center(current_company)
    Company.where.not(name: current_company.name).map { |e| e.name}
  end

  def link_to_request(current_company, customer)
    if current_company.is_broker?
      if current_company.sent_broker_request(customer)
        'Requested'
      elsif current_company.is_broker_or_not(customer)
        'Connected'
      else
        link_to 'Send Request', send_request_brokers_path(s: customer.id), data: { turbolinks: false }
      end
    else
      if current_company.sent_seller_request(customer)
        'Requested'
      elsif current_company.is_seller_or_not(customer)
        'Connected'
      else
        link_to 'Send Request', send_request_brokers_path(s: customer.id), data: { turbolinks: false }
      end
    end
  end

  def check_request_broker(current_company, seller)
    if current_company.sent_broker_request(seller)
      'Requested'
    elsif current_company.is_broker_or_not(seller)
      'Connected'
    else
      'SendRequest'
    end
  end

  def check_request_seller(current_company, broker)
    if current_company.sent_seller_request(broker)
      'Requested'
    elsif current_company.is_seller_or_not(broker)
      'Connected'
    else
      'SendRequest'
    end
  end

  def for_sale_options
    [['All', '0'], ['None', '1'], ['Broker', '2'], ['Credit Given', '3'], ['Demanded', '4']]
  end

  def list_of_brokers(current_company)
    # current_company.my_brokers.map { |e| [e.broker.name, e.broker.id]  } rescue ''
    Customer.all.map{ |e| [e.first_name, e.company.id] if e.has_role?('Broker')}.compact rescue ''
  end

  def all_companies(current_company)
    Company.where.not(id: current_company.id, is_broker: true).map{|comapny| [comapny.name, comapny.id]}
  end

  def all_companies_for_group(current_company, id)
    if id.present?
      group_ids = CompaniesGroup.where.not(id: id).where(seller_id: current_company.id).pluck(:company_id)
    else
      group_ids = CompaniesGroup.where(seller_id: current_company.id).pluck(:company_id)
    end
    group_ids << current_company.id
    Company.where("is_broker != ? AND id NOT IN (?) ", true, group_ids.flatten).map{|comapny| [comapny.name, comapny.id]}
  end

  def list_of_customers(current_customer)
    # customer = Customer.where("id != ? OR id != ? OR parent_id != ? ", current_customer.parent_id , current_customer.id, current_customer.id)
    # array = []
    # requests = current_customer.credit_requests
    # requests.each do |req|
    #   unless req.buyer.nil?
    #    array.push(req.buyer.id)
    #   end
    # end
    # array.push(current_customer.id)
    # array.push(current_customer.parent_id)
    # customer = Customer.where(" id NOT IN (?) ",  array)
    customer = Customer.where(" id != ? ",  current_customer.id)
    customer.map{|customer| [customer.company, customer.id]}
  end

  def list_of_companies_for_credit(current_company)
    companies_groups = CompaniesGroup.where(seller_id: current_company.id)
    excepted_companies_id = companies_groups.map(&:company_id).flatten.uniq
    Company.where.not(id: current_company.id, is_broker: true, id: excepted_companies_id).map{|comapny| [comapny.name, comapny.id]}
  end

  def get_company(c)
    return Company.where(id: c).first
  end

  def get_demanded_but_no_credit(current_company , id)
    count = 0
    @parcel = TradingParcel.where(id: id).first
    @demanded_but_not_available = []
    companies = Company.where.not(id: current_company.id)
    companies.each do |company|
      p = Demand.where(company_id: company.id, description: @parcel.description).first
      if p.present?
        if !company.buyer_credit_limits.where(seller_id: current_company.id).present?
         count = count+1
        end
      end
    end
    count
  end

  def check_for_star(id)
  credit_limit = CreditLimit.where(buyer_id: id, seller_id: current_company.id).first
   if credit_limit.present?
     credit_limit.star
   end
  end

  def get_amount_for_graph(id)
   parcel =  TradingParcel.find(id)
   amount = parcel.cost*(100 + parcel.percent)/100 rescue 0
  end

  # Vital sales data - parcel show
  def get_demanded_clients(parcel, current_company)
    # company_ids = Company.where("name IN (?)", ["Dummy co. 1", "Dummy co. 2", "Dummy co. 3", current_company.id]).map { |e| e.id }
    Demand.where(description: parcel.description, deleted: false).where.not(company_id: current_company.id).map { |e| e.company }
  end

  def check_anonymous_company_parcel(parcel, current_company)
    (current_company.try(:id) == parcel.try(:company_id)) ? parcel.try(:company).try(:name) : (parcel.try(:anonymous) && parcel.try(:company).try(:is_anonymous)) ? 'Anonymous' : parcel.try(:company).try(:name)
  end

  # def country_list
  #   Company.all.map { |e| e.county }.compact.reject { |e| e.to_s == "" }.uniq
  # end


  def self.update_scores
    BuyerScore.calculate_scores_first_step
    SellerScore.calculate_scores_first_step

    BuyerScore.calculate_scores_second_step
    SellerScore.calculate_scores_second_step

    UpdatePercentileRankJob.perform_now
    UpdateSellerPercentileRankJob.perform_now
  end

  def self.safe_divide_float(numerator, denominator, precision = 2)
    result = (numerator / denominator).to_f.round(precision)
    unless result.finite?
      result = 0.0
    end
    return result
  end

  def get_completed_transaction(company)
    total_count = 0.to_i
    @transactions = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and paid = ?',company.id, company.id, true)
    @transactions.each do |transaction|
      if company.id == transaction.buyer_id && (get_status(transaction) == 'Completed')
        total_count = total_count + 1
      end
    end
    return total_count
  end

  def get_market_limit_for_group(buyer, seller)
    pendings = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.current, false, true)
    overdues = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.current, false, true)
    @amount = []
    pendings.each do |t|
      @amount << t.remaining_amount
    end
    overdues.each do |o|
      @amount << o.remaining_amount
    end
    pending_amt = @amount.sum
    number_with_precision(pending_amt, precision: 2)
  end

  def check_for_group_market_limit(buyer,seller)
    total_market_limit = 0.0
    @group = CompaniesGroup.where("company_id like '%#{buyer.id}%'").where(seller_id: seller.id).first
    if @group.present?
      all_members = @group.company_id
      all_members.each do |member|
        company = Company.where(id: member).first
        market_limit = get_market_limit_for_group(company, seller)
        total_market_limit = total_market_limit + market_limit.to_f
      end
      if @group.group_market_limit > total_market_limit
        return false
      else
        return true
      end
    else
      return false
    end
  end

  def check_for_group_overdue_limit(buyer, seller)
    @group = CompaniesGroup.where("company_id like '%#{buyer.id}%'").find_by(seller_id: seller.id)
    if @group.present?
      days_limit = @group.group_overdue_limit
      date = Date.current - days_limit.days
      all_members = @group.company_id
      transaction =  Transaction.where("buyer_id IN (?) AND due_date < ? AND paid = ?", all_members, date, false).order(:due_date).first
      if transaction.present? && transaction.due_date.present?
        overdue_limit = (Date.current.to_date - transaction.due_date.to_date).to_i
        if overdue_limit.to_i > days_limit
          return true
        end
      end
    end
    return false
  end

  def country_list()
    array = [
     'India',
     'U.A.E.',
     'Belgium',
     'Singapore',
     'H.K.',
     'China',
     'South Africa',
     'Botswana',
     'Angola',
     'U.S.A.',
     'U.K.',
     'Zimbabwe'
    ]
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

end
