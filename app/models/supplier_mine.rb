class SupplierMine < ApplicationRecord
  validates :name, presence: true
  belongs_to :supplier

  rails_admin do
    list do
      field :name
      field :supplier do
        label "Supplier"
      end
    end
    edit do
      field :name
      field :supplier do
        label "Supplier"
      end
    end
  end
end
