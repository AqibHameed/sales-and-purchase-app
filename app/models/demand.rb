class Demand < ApplicationRecord
  belongs_to :customer
  belongs_to :demand_supplier


  def self.update_demands_block_unblock
    # Demand.all.each do |d|
    #   customer = d.customer
    #   if customer.is_overdue
    #     d.update_attribute()
    # end
  end
end