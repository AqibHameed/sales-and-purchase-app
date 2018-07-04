class CompaniesGroup < ApplicationRecord
  serialize :company_id, Array

  validates :group_name, :company_id, presence: true

  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
  belongs_to :companies_customer, class_name: 'Company', foreign_key: 'company_id', optional: true
end