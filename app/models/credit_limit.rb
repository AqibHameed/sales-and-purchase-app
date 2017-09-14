class CreditLimit < ApplicationRecord
  validates_numericality_of :credit_limit
end
