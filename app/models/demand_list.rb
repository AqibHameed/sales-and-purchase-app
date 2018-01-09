class DemandList < ApplicationRecord
  validates :supplier_id, :description, presence: true

  rails_admin do
    edit do
      field :description
      field :supplier_id, :enum do
        label "Supplier"
        enum do
          Company.all.map { |c| [ c.name, c.id ] }
        end
      end
    end
  end

end
