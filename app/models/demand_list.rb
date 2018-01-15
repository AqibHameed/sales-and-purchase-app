class DemandList < ApplicationRecord
  validates :demand_supplier_id, :description, presence: true

  rails_admin do
    edit do
      field :description
      field :demand_supplier_id, :enum do
        label "Supplier"
        enum do
          DemandSupplier.all.map { |c| [ c.name, c.id ] }
        end
      end
    end
  end

end
