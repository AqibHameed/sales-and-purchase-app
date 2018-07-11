class PolishedDemand < ApplicationRecord
  belongs_to :company
  belongs_to :demand_supplier
  validates :description, presence: true
  default_scope { where(deleted: false) }
  def self.update_polished_demands_block_unblock
    PolishedDemand.all.each do |d|
      company = d.company
      if company.is_overdue
        d.update_attribute(:block, true)
      else
        d.update_attribute(:block, false)
      end
    end
  end
end