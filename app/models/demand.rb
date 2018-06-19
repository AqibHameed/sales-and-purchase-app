class Demand < ApplicationRecord
  belongs_to :company
  belongs_to :demand_supplier
  default_scope { where(deleted: false) }
  def self.update_demands_block_unblock
    Demand.all.each do |d|
      company = d.company
      if company.is_overdue
        d.update_attribute(:block, true)
      else
        d.update_attribute(:block, false)
      end
    end
  end
end