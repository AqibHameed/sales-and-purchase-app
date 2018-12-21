class DemandSupplier < ApplicationRecord
  has_many :demand_list
  has_many :demands
  has_many :polished_demands
  DTC = 'Sight'
  RUSSIAN = 'RUSSIAN'
  OUTSIDE = 'OUTSIDE'
  SPECIAL = 'SPECIAL'
  POLISHED = 'POLISHED'
end
