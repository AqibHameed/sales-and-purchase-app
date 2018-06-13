class Company < ApplicationRecord
  has_many :customers
  has_many :trading_parcels

  validates :name, presence: true

  def get_owner
    Customer.unscoped do
      customers.order(:id).first
    end
  end
end
