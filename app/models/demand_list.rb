class DemandList < ApplicationRecord
  validates :supplier_id, :description, presence: true

  rails_admin do
    edit do
      field :description
      field :supplier_id, :enum do
        label "Supplier"
        enum do
          Customer.all.map { |c| [ c.company, c.id ] }
        end
      end
    end
  end

end
