class SupplierMine < ApplicationRecord
  validates :name, presence: true
  belongs_to :company

  rails_admin do
    list do
      field :name
      field :company do
        label "Supplier"
      end
    end
    edit do
      field :name
      field :company do
        label "Supplier"
      end
    end
  end
end
