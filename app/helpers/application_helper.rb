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
    if parcel.description.nil?
      return "#{parcel.source} #{parcel.box}"
    else
      return parcel.description
    end
  end

end

