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

    if bid.to_f ==  sell.to_f
      return "<font color='green'>Won the Bid</font>"
    else
      return (100.0 - (bid / sell.to_f * 100)).round(2).to_s + ' %'
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
        return parcel.description
      end
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
    cl = CreditLimit.where(buyer_id: buyer.id, supplier_id: supplier.id).first
    if cl.nil? || cl.credit_limit.nil? || cl.credit_limit.blank?
      0.00
    else
      number_with_precision((cl.credit_limit), precision: 2)
    end
  end

  def get_available_credit_limit(buyer, supplier)
    total = get_credit_limit(buyer, supplier)
    used  =  get_used_credit_limit(buyer, supplier)
    number_with_precision((total.to_f - used.to_f), precision: 2)
  end

  def get_used_credit_limit(buyer, supplier)
    transaction_amt = Transaction.where(buyer_id: buyer.id, supplier_id: supplier.id, paid: false).sum(:price)
    number_with_precision(transaction_amt, precision: 2)
  end

  def overall_credit_received(customer)
    current_limit = CreditLimit.where(buyer_id: customer.id).sum(:credit_limit)
    transaction_amt = Transaction.where(buyer_id: customer.id, paid: false).sum(:price)
    number_with_precision((transaction_amt + current_limit), precision: 2)
  end

  def overall_credit_spent(customer)
    transaction_amt = Transaction.where(buyer_id: customer.id).sum(:price)
    number_with_precision(transaction_amt, precision: 2)
  end

  def overall_credit_given(customer)
    current_limit = CreditLimit.where(supplier_id: customer.id).sum(:credit_limit)
    transaction_amt = Transaction.where(supplier_id: customer.id, paid: false).sum(:price)
    number_with_precision((transaction_amt.to_f + current_limit.to_f), precision: 2)
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

  def customer_list
    Customer.unscoped.where.not(id: current_customer.id).order('company asc, first_name asc').map { |e| [(e.company.nil? || e.company.blank?) ? e.name : e.company, e.id] }
  end

  def show_buyer_links
    if current_page?(trading_customers_path) || current_page?(transactions_customers_path) || current_page?(credit_customers_path)
      true
    else
      false
    end
  end
end

