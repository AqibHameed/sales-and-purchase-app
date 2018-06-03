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

  # def get_credit_purchase_percentage(count,total)
  #  return (count/total)*100
  # end

  def count_value(condition, total, option,customer)
    if condition == '0'
      transactions = Transaction.where('credit = ? and buyer_id =?', 0, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, Date.today, false, true, 0).sum(:total_amount)
      overdue = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, Date.today, false, true, 0).sum(:total_amount)
      complete = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, true, true, 0).sum(:total_amount)
    elsif condition =='less_30'
      transactions = Transaction.where('credit >= ? and credit <= ? and buyer_id =?',1, 30, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, Date.today, false, true, 1, 0).sum(:total_amount)
      overdue = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, Date.today, false, true, 1, 30).sum(:total_amount)
      complete = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, true, true, 1, 30).sum(:total_amount)
    elsif condition =='60'
      transactions = Transaction.where('credit > ? and credit <= ? and buyer_id =?', 30, 60, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.today, false, true, 30, 60).sum(:total_amount)
      overdue = Transaction.where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.today, false, true, 30, 60).sum(:total_amount)
      complete = Transaction.where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, true, true, 30, 60).sum(:total_amount)
    elsif condition =='90'
      transactions = Transaction.where('credit > ? and credit <= ? and buyer_id =?', 60, 90, customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.today, false, true, 60, 90).sum(:total_amount)
      overdue = Transaction.where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.today, false, true, 60, 90).sum(:total_amount)
      complete = Transaction.where("buyer_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, true, true, 60, 90).sum(:total_amount)
    else
      transactions = Transaction.where('credit > ? and buyer_id =?', 90,customer.id)
      count = transactions.count
      pending = Transaction.where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", customer.id, Date.today, false, true, 90).sum(:total_amount)
      overdue = Transaction.where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", customer.id, Date.today, false, true, 90).sum(:total_amount)
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

  def sale_count_value(condition,total,option,customer)
    if condition == '0'
      transactions = Transaction.where('credit = ? and supplier_id =?', 0, customer.id)
      count = transactions.count
      pending = Transaction.where("supplier_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, Date.today, false, true, 0).sum(:total_amount)
      overdue = Transaction.where("supplier_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, Date.today, false, true, 0).sum(:total_amount)
      complete = Transaction.where("supplier_id = ? AND paid = ? AND buyer_confirmed = ? AND credit = ?", customer.id, true, true, 0).sum(:total_amount)
    elsif condition == 'less_30'
      transactions = Transaction.where('credit >= ? and credit <= ? and supplier_id =?', 1, 30, customer.id)
      count = transactions.count
      pending = Transaction.where("supplier_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, Date.today, false, true, 1, 30).sum(:total_amount)
      overdue = Transaction.where("supplier_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, Date.today, false, true, 1, 30).sum(:total_amount)
      complete = Transaction.where("supplier_id = ? AND paid = ? AND buyer_confirmed = ? AND credit >= ? and credit <= ?", customer.id, true, true,1,30).sum(:total_amount)
    elsif condition == '60'
      transactions = Transaction.where('credit > ? and credit <= ? and supplier_id =?', 30, 60, customer.id)
      count = transactions.count
      pending = Transaction.where("supplier_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.today, false, true,30,60).sum(:total_amount)
      overdue = Transaction.where("supplier_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.today, false, true,30,60).sum(:total_amount)
      complete = Transaction.where("supplier_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, true, true,30,60).sum(:total_amount)
    elsif condition == '90'
      transactions = Transaction.where('credit > ? and credit <= ? and supplier_id =?', 60, 90, customer.id)
      count = transactions.count
      pending = Transaction.where("supplier_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit > ?  and credit <= ?", customer.id, Date.today, false, true, 60, 90).sum(:total_amount)
      overdue = Transaction.where("supplier_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, Date.today, false, true, 60, 90).sum(:total_amount)
      complete = Transaction.where("supplier_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ? and credit <= ?", customer.id, true, true, 60, 90).sum(:total_amount)
    else
      transactions = Transaction.where('credit > ? and supplier_id =?', 90, customer.id)
      count = transactions.count
      pending = Transaction.where("supplier_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ? AND credit >?", customer.id, Date.today, false, true, 90).sum(:total_amount)
      overdue = Transaction.where("supplier_id =? AND due_date < ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", customer.id, Date.today, false, true, 90).sum(:total_amount)
      complete = Transaction.where("supplier_id = ? AND paid = ? AND buyer_confirmed = ? AND credit > ?", customer.id, true, true, 90).sum(:total_amount)
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

  def index_count page
    if page == 0
      return 0
    else
      (page - 1)*25
    end
  end

  def get_credit_limit(buyer, supplier)
    if current_customer.parent_id?
      sub_company_limit = SubCompanyCreditLimit.find_by(sub_company_id: supplier.id)
      if sub_company_limit.try(:credit_type) == "Yours"
        cl = credit_limit(buyer.id, current_customer.parent_id)
      else
        cl = credit_limit(buyer.id, supplier.id)
      end
    else
      cl = credit_limit(buyer.id, supplier.id)
    end
    if cl.nil? || cl.credit_limit.nil? || cl.credit_limit.blank?
      number_with_precision(0, precision: 2)
    else
      number_with_precision((cl.credit_limit), precision: 2)
    end
  end

  def credit_limit(buyer_id, supplier_id)
    CreditLimit.where(buyer_id: buyer_id, supplier_id: supplier_id).first
  end

  def get_days_limit(buyer, supplier)
    dl = DaysLimit.where(buyer_id: buyer.id, supplier_id: supplier.id).first
    if dl.nil? || dl.days_limit.nil? || dl.days_limit.blank?
      pluralize(30, 'day')
    else
      pluralize(dl.days_limit.to_i, 'day')
    end
  end

  def get_available_credit_limit(buyer, supplier)
    total = get_credit_limit(buyer, supplier)
    used  =  get_used_credit_limit(buyer, supplier)
    number_with_precision((total.to_f - used.to_f), precision: 2)
  end

  def get_number_of_customers(supplier, amount,check)
    count = 0
    count1 = 0
    buyer_ids = CreditLimit.where(supplier_id: supplier.id).map { |e| e.buyer_id  }
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
    buyer_ids = CreditLimit.where(supplier_id: supplier.id).map { |e| e.buyer_id  }
    buyers = Customer.where.not(id: buyer_ids)
    buyers.count-1
  end

  def supplier_connected(buyer,customer)
    count = CreditLimit.where("buyer_id =? and supplier_id !=?", buyer, customer.id).count
  end

  def get_used_credit_limit(buyer, supplier)
    transactions = Transaction.where(buyer_id: buyer.id, supplier_id: supplier.id, paid: false, buyer_confirmed: true)
    @amount = []
    transactions.each do |t|
      @amount << t.remaining_amount
    end
    transaction_amt = @amount.sum
    number_with_precision(transaction_amt, precision: 2)
  end

  def get_market_limit(buyer, supplier)
    pendings = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date >= ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.today, false, true)
    overdues = Transaction.includes(:trading_parcel).where("buyer_id = ? AND due_date < ? AND paid = ? AND buyer_confirmed = ?",buyer.id, Date.today, false, true)

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

  def get_market_limit_from_credit_limit_table(buyer, supplier)
    CreditLimit.where(supplier_id: supplier.id, buyer_id: buyer.id).first.market_limit.to_i rescue 0
  end

  def overall_credit_received(customer)
    current_limit = CreditLimit.where(buyer_id: customer.id).sum(:credit_limit)
    number_with_precision((current_limit), precision: 2)
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

  def overall_credit_given(customer)
    current_limit = CreditLimit.where(supplier_id: customer.id).sum(:credit_limit)
    number_with_precision((current_limit), precision: 2)
  end

  def overall_credit_spent_by_customer(customer)
    transactions = Transaction.where(supplier_id: customer.id)
    @amount = []
    transactions.each do |t|
      @amount << t.remaining_amount
    end
    transaction_amt = @amount.sum
    number_with_precision(transaction_amt, precision: 2)
  end

  def credit_available(customer)
    number_to_currency(overall_credit_given(customer).to_f-overall_credit_spent_by_customer(customer).to_f)
  end

  def get_status transaction
    if !transaction.buyer_confirmed
      'Awaiting Confirmation'
    elsif transaction.paid
      'Completed'
    else
      if transaction.due_date.nil? || transaction.due_date.blank?
        'N/A'
      elsif (transaction.due_date > Date.today) && (transaction.paid == false)
        'Pending Payment'
      elsif (transaction.due_date < Date.today) && (transaction.paid == false)
        'Overdue'
      end
    end
  end

  def grey_buy_btn(buyer, supplier)
    cl = CreditLimit.where(buyer_id: buyer, supplier_id: supplier).first
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
      Customer.unscoped.where.not(id: current_customer.id).order('company asc, first_name asc').map { |e| [(e.company.nil? || e.company.blank?) ? e.name : e.company, e.id, e.verified] }
    else
      Customer.unscoped.where.not(id: current_customer.id).order('company asc, first_name asc').map { |e| [(e.company.nil? || e.company.blank?) ? e.name : e.company, e.id] }
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

  def supplier_list_for_demand
    DemandSupplier.all.map { |e| e.name }
  end

  def link_to_request(current_customer, seller)
    puts current_customer.sent_broker_request(seller)
    if current_customer.sent_broker_request(seller)
      'Requested'
    elsif current_customer.is_broker(seller)
      'Connected'
    else
      link_to 'Send Request', send_request_brokers_path(s: seller.id), data: { turbolinks: false }
    end
  end

  def for_sale_options
    [['All', '0'], ['None', '1'], ['Broker', '2'], ['Credit Given', '3'], ['Demanded', '4']]
  end

  def list_of_brokers(current_customer)
    current_customer.my_brokers.map { |e| [e.broker.name, e.broker.id]  }
  end

  def all_customers(current_customer)
    Customer.where.not(id: current_customer.id).map{|customer| [customer.company, customer.id]}
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

  def get_customer(c)
    return Customer.where(id: c).first
  end

  def get_demanded_but_no_credit(current_customer , id)
    count = 0
    @parcel = TradingParcel.where(id: id).first
    @demanded_but_not_available = []
    customers = Customer.unscoped.where.not(id: current_customer.id)
    customers.each do |customer|
      p = Demand.where(customer_id: customer.id, description: @parcel.description).first
      if p.present?
        if !customer.buyer_credit_limits.where(supplier_id: current_customer.id).present?
         count = count+1
        end
      end
    end
    count
  end
end