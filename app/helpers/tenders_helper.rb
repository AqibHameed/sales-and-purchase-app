module TendersHelper
  def time_remaining(close_date)

    if close_date < Time.now
      'Closed'
    else
      time_ago_in_words(close_date)
    end
    #return close_date
  end

  def delete_stones_tender_path(id)
    "/tenders/#{id}/delete_stones"
  end

  def bid_confirmation_link(tender, customer)
    if CustomersTender.find_by_tender_id_and_customer_id(tender.id, customer.id).try(:confirmed)
      time_remaining(tender.close_date) == 'Closed' ? "Confirmed" : "Confirmation sent &nbsp; #{link_to 'Undo', undo_confirmation_tender_path(tender), :method => :put}".html_safe
    else
      time_remaining(tender.close_date) == 'Closed' ? "Time Over" : (link_to 'Send Confirmation', confirm_bids_tender_path(tender))
    end
  end

  def last_bkground(avg)
    avg = avg.to_f
    if avg > "1.0".to_f
      "green_bkground"
    elsif avg.between?(0.95, 1.0)
      "blue_bkground"
    elsif avg.between?(0.9, 0.95)
      "dblue_bkground"
    elsif avg.between?(0.85, 0.9)
      "violet_bkground"
    elsif avg.between?(0.8, 0.85)
      "pink_bkground"
    elsif avg.between?(0.75, 0.8)
      "red_bkground"
    else
      "yellow_bkground"
    end          
  end
end