class DemandSupplier < ApplicationRecord
  has_many :demand_list
  has_many :demands
  has_many :polished_demands
  DTC = 'DTC'
  RUSSIAN = 'RUSSIAN'
  OUTSIDE = 'OUTSIDE'
  SPECIAL = 'SPECIAL'
  POLISHED = 'POLISHED'
end
