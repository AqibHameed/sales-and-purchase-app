class Demand < ApplicationRecord
  belongs_to :customer
  belongs_to :demand_supplier
end