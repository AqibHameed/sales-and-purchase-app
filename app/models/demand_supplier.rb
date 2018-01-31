class DemandSupplier < ApplicationRecord
  has_many :demand_list
  has_many :demands
end
