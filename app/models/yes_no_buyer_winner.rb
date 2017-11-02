class YesNoBuyerWinner < ApplicationRecord
	
	belongs_to :tender, optional: true
	belongs_to :customer, required: true
	belongs_to :stone, optional: true
	belongs_to :sight, optional: true
	belongs_to :yes_no_buyer_interest, optional: true

end

