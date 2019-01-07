class Role < ApplicationRecord
  # has_many :customer_roles
  # has_many :customers, through: :customer_roles
  TRADER = 'Trader'
  BROKER = 'Broker'
  BUYER = 'Buyer'
  SUPPLIER = 'Supplier'
end
