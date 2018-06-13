class TradingParcel < ApplicationRecord
  serialize :broker_ids
  paginates_per 25
  belongs_to :customer
  belongs_to :company
  has_many :proposals
  has_many :parcel_size_infos
  has_one :my_transaction, class_name: 'Transaction'
  belongs_to :trading_document, optional: true
  validates :source, presence: true, if: :diamond_type_is_sight?
  validates :credit_period, :total_value, :description, presence: true
  validates :price, :credit_period, :weight, :total_value, numericality: true
  after_create :generate_and_add_uid, :send_mail_to_demanded
  before_create :set_defaults

  accepts_nested_attributes_for :my_transaction
  accepts_nested_attributes_for :parcel_size_infos, :allow_destroy => true
  validate :validate_carats
  attr_accessor :single_parcel

  enum for_sale: [ :to_all, :to_none, :broker, :credit_given, :demanded ]

  def diamond_type_is_sight?
     self.diamond_type == "Sight"
  end

  def validate_carats
    sum = 0.0
    parcel_size_infos.each do |p1|
      sum = sum + p1["size"].to_f
    end
    if sum > self.weight
     self.errors.add :base, "Sum of sizes should be less than carats!!!"
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

  def demand_count(parcel, customer)
    count = Demand.where(description: parcel.description, block: false, deleted: false).where.not(customer_id: customer.id).count
    # customer_ids = demands.customer_ids
    # customer_ids.each do |id|
    #   Customer.check_overdue(id)
    # end
    return count
  end

  def related_parcels(customer)
    networks = BrokerRequest.where(broker_id: customer.id, accepted: true).map { |e| e.seller_id } #. delete(customer.id.to_i)
    networks.delete(self.customer_id)
    parcels = TradingParcel.where(description: description, customer_id: networks)
  end

  def send_mail_to_demanded
    demands = Demand.where(description: self.description, demand_supplier_id: self.customer_id).map { |e| e.customer.email }
    TenderMailer.parcel_up_email(self, demands).deliver rescue logger.info "Error sending email"
  end

  def self.send_won_parcel_email(proposal)
    customer = proposal.buyer
    parcel = proposal.trading_parcel
    TenderMailer.parcel_won_email(customer, parcel).deliver rescue logger.info "Error sending email"
  end

  def set_defaults
    self.sale_all = true
    self.sale_none = false
  end
end