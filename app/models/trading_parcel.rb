class TradingParcel < ApplicationRecord
  serialize :broker_ids
  paginates_per 25

  belongs_to :customer, optional: true
  belongs_to :company
  has_many :proposals
  has_many :parcel_size_infos
  has_one :my_transaction, class_name: 'Transaction'
  belongs_to :trading_document, optional: true

  validates :description, presence: true, unless: :diamond_type_is_polish?
  validates :source, :credit_period, :total_value, :price, :weight, presence: true
  # validates :price, :credit_period, :weight, :total_value, numericality: true, allow_blank: true, unless: :diamond_type_is_polish?

  after_create :generate_and_add_uid, :send_mail_to_demanded, :replace_nil_value
  after_update :set_sale_none_when_all_none, :replace_nil_value

  accepts_nested_attributes_for :my_transaction
  accepts_nested_attributes_for :parcel_size_infos, :allow_destroy => true
  validate :validate_carats, unless: :diamond_type_is_polish?
  attr_accessor :single_parcel

  enum for_sale: [ :to_all, :to_none, :broker, :credit_given, :demanded ]

  SHAPE = ["Round", "Princess", "Emerald", "Sq. Emerald", "Asscher", "Radiant", "Square Radiant", "Cushion Brilliant", "Cushion Modified", "Pear"]
  COLOR = ["D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S"]
  CLARITY= ["FL", "IF", "VVS1", "VVS2", "VS1", "VS2", "SI1", "SI2", "SI3", "I1", "I2", "I3"]

  CUT_POLISH_SYMMETRY = ["Excellent", "Very Good", "Good", "Fair", "Poor"]

  FLUORESCENCE = ["None", "Very Slight", "Faint/Slight", "Medium", "Strong", "Very Stong"]
  LAB = ["GIA", "AGS", "HRD", "IGI", "RDC", "CGL", "DCLA", "GCAL", "GHI", "IIDGR"]

  def diamond_type_is_polish?
    self.source == "POLISHED"
  end

  def validate_carats
    sum = 0.0
    parcel_size_infos.each do |p1|
      sum = sum + p1["size"].to_f
    end
    if self.weight.present?
      if sum > self.weight
       self.errors.add :base, "Sum of sizes should be less than carats!!!"
      end
    end
  end

  def self.search_by_filters(params, current_customer)
    parcels = TradingParcel.where.not(customer_id: current_customer.id).order(created_at: :desc)
    parcels = parcels.where("description like ? OR box like ? OR source like ?", "%#{params[:description]}%", "%#{params[:description]}%", "%#{params[:description]}%") unless params[:description].blank?
    parcels = parcels.where(customer_id: params[:company_id]) unless params[:company_id].blank?
    parcels = parcels.where(no_of_stones: params[:no_of_stones]) unless params[:no_of_stones].blank?
    parcels = parcels.where(weight: params[:weight]) unless params[:weight].blank?
    parcels = parcels.where(credit_period: params[:credit_period]) unless params[:credit_period].blank?
  end

  def generate_and_add_uid
    uid = SecureRandom.hex(4)
    self.uid = uid
    self.save(validate: false)
  end

  def demand_count(parcel, company, is_polished)
    count = is_polished ? PolishedDemand.where(description: parcel.description, block: false, deleted: false).where.not(company_id: company.id).count: Demand.where(description: parcel.description, block: false, deleted: false).where.not(company_id: company.id).count
    return count
  end

  def related_parcels(company)
    networks = BrokerRequest.where(broker_id: company.id, accepted: true).map { |e| e.seller_id }
    networks.delete(self.company)
    parcels = TradingParcel.where(description: description, company_id: networks, sold: false)
  end

  def send_mail_to_demanded
    demands = Demand.where.not(company_id: company_id).where(description: self.try(:description)).map{|e| e.company.try(:customers).map(&:email)}.flatten.uniq
    unless demands.blank?
      TenderMailer.parcel_up_email(self, demands).deliver rescue logger.info "Error sending email"
    end
  end

  def self.send_won_parcel_email(proposal)
    customer = proposal.buyer
    parcel = proposal.trading_parcel
    TenderMailer.parcel_won_email(customer, parcel).deliver rescue logger.info "Error sending email"
  end

  def set_sale_none_when_all_none
    (!sale_all && !sale_none && !sale_broker && !sale_credit && !sale_demanded) ? self.update_column(:sale_none, true) : ''
  end

  def replace_nil_value
    cost.nil? ? self.update_column(:cost, 0) : ''
    percent.nil? ? self.update_column(:percent, 0) : ''
    weight.nil? ? self.update_column(:weight, 0) : ''
    price.nil? ? self.update_column(:price, 0) : ''
  end
end