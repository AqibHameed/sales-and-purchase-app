class CompaniesGroup < ApplicationRecord
  serialize :customer_id, Array

  belongs_to :seller, class_name: 'Customer', foreign_key: 'seller_id'
  belongs_to :companies_customer, class_name: 'Customer', foreign_key: 'customer_id', optional: true
end