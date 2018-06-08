class Company < ApplicationRecord
  has_many :customers

  validates :name, presence: true

  def get_owner
    Customer.unscoped do
      customers.order(:id).first
    end
  end
end
