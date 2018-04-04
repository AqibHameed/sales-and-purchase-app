class CreditRequest < ApplicationRecord
	belongs_to :customer
	belongs_to :buyer, :class_name => 'Customer', :foreign_key => 'buyer_id'
	validates :limit, presence: true
end
