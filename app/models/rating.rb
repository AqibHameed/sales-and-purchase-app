class Rating < ApplicationRecord

  attr_accessible :customer_id, :key, :score, :tender_id
  rails_admin do
  	visible false
  end
end
