class TradingParcel < ApplicationRecord
  paginates_per 25
  belongs_to :customer
  has_many :proposals
  has_one :my_transaction, class_name: 'Transaction'

  validates :price, :credit_period, :weight, presence: true
  validates :price, :credit_period, :weight, numericality: true
  after_create :generate_and_add_uid

  accepts_nested_attributes_for :my_transaction

  attr_accessor :single_parcel

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

  def demand_count(parcel,customer)
    description = parcel.description
    customer_id = parcel.customer_id
    count = Demand.where(description: description, supplier_id: customer_id).where.not(customer_id: customer.id).count
    return count
  end

end
