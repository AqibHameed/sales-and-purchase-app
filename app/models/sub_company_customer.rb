class SubCompanyCustomer < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :sub_company_credit_limit
end
