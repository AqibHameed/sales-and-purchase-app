class YesNoBuyerInterest < ApplicationRecord
	belongs_to :tender, optional: true
	belongs_to :customer, optional: true
	belongs_to :stone, optional: true
	belongs_to :sight, optional: true
	has_one :yes_no_buyer_winner


  def set_buyer_left(sight_check)
   sight_check.update_attributes(buyer_left: true)
  end

  def break_duration
    if self.bid_open_time.present?
      if Time.current < (self.bid_open_time.to_i + self.tender.round_duration.minutes + self.tender.rounds_between_duration.minutes)
        (self.bid_open_time.to_i + self.tender.round_duration.minutes + self.tender.rounds_between_duration.minutes) - Time.current.to_i
      end
    end

  end

  def before_bidding_start
   if DateTime.now.to_i < self.bid_open_time.to_i  and self.round == 1
    return true
  else
    return false
    end
end

  def break_time
    if (DateTime.now.to_i <  (self.bid_open_time.to_i + self.tender.round_duration.minutes)) && (DateTime.now.to_i >  (self.bid_open_time.to_i + self.tender.round_duration.minutes + self.tender.rounds_between_duration.minutes))
      return true
    else
      return false
    end
  end

   def bidding_start
    if DateTime.now.to_i >  self.bid_open_time.to_i  && (DateTime.now.to_i <  (self.bid_open_time.to_i + self.tender.round_duration.minutes))
      return true
    else
      return false
    end
  end



  def round_duration_time
    if self.bid_open_time.present?
      if Time.current < self.bid_open_time.to_i
        self.bid_open_time.to_i  - Time.current.to_i
      end
    end
  end

  def bidding_time
    if self.bid_open_time.present?
      if Time.current < (self.bid_open_time.to_i + self.tender.round_duration.minutes)
        (self.bid_open_time.to_i + self.tender.round_duration.minutes) - Time.current.to_i
      end
    end
  end
end
