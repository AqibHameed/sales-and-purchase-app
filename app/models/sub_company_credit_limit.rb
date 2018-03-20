class SubCompanyCreditLimit < ApplicationRecord
  belongs_to :customer, :foreign_key => "sub_company_id", optional: true
  has_many   :sub_company_customers, :dependent => :destroy
end
