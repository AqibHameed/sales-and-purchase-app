class Rating < ApplicationRecord

  attr_accessible :customer_id, :key, :score, :tender_id, :flag_type
  rails_admin do
  	visible false
  end
end
