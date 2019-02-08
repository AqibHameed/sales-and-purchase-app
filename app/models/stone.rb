class Stone < ApplicationRecord
  paginates_per 25

  attr_accessible :stone_type, :no_of_stones, :weight, :carat, :purity, :color, :polished, :size,
                  :deec_no, :lot_no, :description, :tender_id, :reserved_price, :system_price, :yes_no_system_price, :stone_winning_price, :interest,
                  :comments, :valuation, :parcel_rating, :status
  # attr_accessible :stone_type, :no_of_stones, :weight, :carat, :purity, :color, :polished, :size,
  #                 :deec_no, :lot_no, :description, :tender_id

  has_many :stone_details
  has_many :bids
  has_many :parcel_images, :foreign_key => "parcel_id", :class_name => "ParcelImage"
  has_many :stone_ratings
  has_one :winner
  has_one :yes_no_buyer_winner
  has_one :note
  has_many :yes_no_buyer_interests
  validates_presence_of :lot_no, :tender_id, :description

  validates_numericality_of :no_of_stones, :weight, :carat, :allow_blank => true

  belongs_to :tender

  before_save{|stone|
    stone.no_of_stones = 1 if stone.no_of_stones.blank?
  }

  enum status: [:unsold, :withdrawn, :sold]


  def per_carat_bid(customer)
    bid = self.bids.find_by_customer_id(customer.id)
    bid.blank? ? '' : bid.price_per_carat
  end

  def total_bid(customer)
    bid = self.bids.find_by_customer_id(customer.id)
    bid.blank? ? '' : bid.total
  end

  def customer_bid_amount(customer)
    bid = self.bids.where(customer_id: customer.id).first
    if bid.nil?
      'N/A'
    else
      number_to_currency bid.total
    end
  end

  def winning_bid
    Bid.where(:id => self.id).order('total DESC').first
  end

  def winning_customer
    winning_bid.blank? ? '' : winning_bid.customer.name
  end

  def name
    self.lot_no.blank? ? "stone #{self.id}" : self.lot_no
  end

  def top_bid
    stone_id = self.id
    Bid.find_by_sql("
      SELECT b.* FROM tenders t
      INNER JOIN customers_tenders ct ON t.id = ct.tender_id
      INNER JOIN customers c ON c.id = ct.customer_id
      INNER JOIN bids b ON (b.customer_id = c.id AND b.tender_id = t.id)
      where b.stone_id = #{self.id}
      ORDER BY b.total DESC, b.id ASC
      LIMIT 1
    ")
    #    self.bids.order('total DESC, id ASC').limit(1)
  end

  def top_3_bids
    stone_id = self.id
    Bid.find_by_sql("
      SELECT b.* FROM tenders t
      INNER JOIN customers_tenders ct ON t.id = ct.tender_id
      INNER JOIN customers c ON c.id = ct.customer_id
      INNER JOIN bids b ON (b.customer_id = c.id AND b.tender_id = t.id)
      where b.stone_id = #{self.id}
      ORDER BY b.total DESC, b.id ASC
      LIMIT 3
    ")
    #    self.bids.order('total DESC, id ASC').limit(1)
  end


  def top_two_bids
    stone_id = self.id
    Bid.find_by_sql("
      SELECT b.* FROM tenders t
      INNER JOIN customers_tenders ct ON t.id = ct.tender_id
      INNER JOIN customers c ON c.id = ct.customer_id
      INNER JOIN bids b ON (b.customer_id = c.id AND b.tender_id = t.id)
      where ct.confirmed = #{true}
      AND b.stone_id = #{self.id}
      ORDER BY b.total DESC, b.id ASC
      LIMIT 2
    ")
  end

  def key
    "#{self.description}##{ self.weight.to_s}"
  end

  def self.active_parcels term
    # mysql
    Tender.find_by_sql(
      "SELECT tenders.name, s.* FROM tenders 
      left join stones s on s.tender_id = tenders.id
      WHERE (open_date <= '#{Time.now.utc}'
      AND close_date >= '#{Time.now.utc}')
      AND (CAST(s.weight as decimal(10, 2))) = #{term}"
    )

    # # pg
    # Tender.find_by_sql(
    #   "SELECT tenders.name, s.* FROM tenders 
    #   left join stones s on s.tender_id = tenders.id
    #   WHERE (open_date <= '#{Time.now.utc}'
    #   AND close_date >= '#{Time.now.utc}')
    #   AND (s.weight = #{term} OR s.lot_no = #{term})"
    # )
  end

  def has_note? customer
    if self.try(:note).try(:customer_id) == customer.id
      true
    else
      false                                                                                     
    end
  end

  def has_bid? customer
    if self.try(:bids).map { |e| e.customer_id  }.include?(customer.id)
      true
    else
      false                                                                                 
    end
  end

  rails_admin do
    label "Stone List"
    list do
      [:tender, :lot_no, :deec_no, :no_of_stones, :stone_type, :weight, :description].each do |field_name|
        field field_name
      end
    end
    edit do
      field :tender
      field :stone_type, :enum do
        enum do
          ['Stone', 'Parcel']
        end
      end
      [:deec_no, :lot_no, :description, :no_of_stones, :weight].each do |field_name|
        field field_name
      end
    end
  end
end