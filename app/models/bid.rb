class Bid < ApplicationRecord

  attr_accessible :total, :bid_date, :customer_id, :tender_id, :no_of_parcels, :price_per_carat

  has_one :winner

  belongs_to :tender, optional: true
  belongs_to :customer, required: true
  belongs_to :stone, optional: true
  belongs_to :sight, optional: true
  validates_presence_of :total, :customer_id

  # validates_uniqueness_of :stone_id, :scope => :customer_id

  before_save :set_bid_date_and_lot_no, :set_tender_id

  def set_bid_date_and_lot_no
    self.bid_date = DateTime.now
  #  self.lot_no = self.stone.lot_no
  end

  def set_tender_id
    # self.tender_id = self.stone.tender_id
  end

  def stone_description
    stone.try(:description)
  end

  rails_admin do
    configure :stone_description do
      pretty_value do
        data = bindings[:object].try(:stone).try(:description)
        data
      end
    end
    list do
      [ :tender, :customer, :total, :price_per_carat].each do |field_name|
        field field_name
      end
      field :stone do
        label "Lot No / List"
      end
      field :stone_description do
        label "Description"
      end
      field :created_at do
        strftime_format "%Y-%m-%d %I:%M"
      end
    end
    edit do
      [:id, :total, :price_per_carat, :tender, :customer]. each do |field_name|
        field field_name
      end
      field :stone do
        label "Lot No / List"
        read_only true
      end
      field :stone_description do
        label "Description"
        read_only true
      end
    end
  end
end

