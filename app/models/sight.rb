class Sight < ApplicationRecord

	has_many :bids
	has_one :winner
  has_one :yes_no_buyer_winner
	has_one :note
	belongs_to :tender
  has_many :yes_no_buyer_interests

  enum status: [:unsold, :withdrawn, :sold]
  
  def per_carat_bid(customer)
    bid = self.bids.find_by_customer_id(customer.id)
    bid.blank? ? '' : bid.price_per_carat
  end

  def total_bid(customer)
    bid = self.bids.find_by_customer_id(customer.id)
    bid.blank? ? '' : bid.total
  end
  
  def key
    "#{self.box}##{self.carats}"
  end

  rails_admin do
    label "Sight List"
    list do
      [:tender, :source, :box, :carats, :cost, :box_value_from, :box_value_to, :sight, :price, :sight_reserved_price, :credit].each do |field_name|
        field field_name
      end
    end
    edit do
      field :tender
      # field :sight_type, :enum do
      #   enum do
      #     ['Stone', 'Parcel']
      #   end
      # end
      [:source, :box, :carats, :cost, :box_value_from, :box_value_to, :sight, :price, :sight_reserved_price, :credit].each do |field_name|
        field field_name
      end

    end
  end

end
