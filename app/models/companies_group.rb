class CompaniesGroup < ApplicationRecord
  include LiveMonitor
  
  serialize :company_id, Array

  validates :group_name, :company_id, :group_overdue_limit, presence: true

  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
  belongs_to :companies_customer, class_name: 'Company', foreign_key: 'company_id', optional: true
  after_save :update_secure_center

  def self.remove_credit_limits(companies, current_company)
    CreditLimit.where(buyer_id: companies, seller_id: current_company.id).destroy_all
  end
end