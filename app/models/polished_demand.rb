class PolishedDemand < ApplicationRecord
  belongs_to :company
  belongs_to :demand_supplier
  default_scope { where(deleted: false) }
  validates :shape, :weight_from, :weight_to, :color_from, :color_to, :clarity_from, :clarity_to, :cut_from, :cut_to, :polish_from, :polish_to, :symmetry_from, :symmetry_to, :fluorescence_from, :fluorescence_to, :lab, presence: true

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