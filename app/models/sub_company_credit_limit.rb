class SubCompanyCreditLimit < ApplicationRecord
  belongs_to :customer, :foreign_key => "sub_company_id", optional: true
end
