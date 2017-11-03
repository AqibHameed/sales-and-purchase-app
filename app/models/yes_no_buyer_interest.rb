class YesNoBuyerInterest < ApplicationRecord
	belongs_to :tender, optional: true
	belongs_to :customer, optional: true
	belongs_to :stone, optional: true
	belongs_to :sight, optional: true
	has_one :yes_no_buyer_winner
end
