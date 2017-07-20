class CustomerComment < ApplicationRecord
  belongs_to :customer
  belongs_to :tender
  belongs_to :stone

  validates :description, presence: true

  rails_admin do
    list do
      [:customer, :tender, :stone, :description, :created_at].each do |field_name|
        field field_name
      end
    end
    edit do
      field :tender_id, :enum do
        label "Tender"
        enum do
          Tender.all.map { |c| [ c.name, c.id ] }
        end
      end
      field :customer_id, :enum do
        label "Customer"
        enum do
          Customer.all.map { |c| [ c.name, c.id ] }
        end
      end
      field :stone_id do
        label "Parcel"
      end
      field :description
    end
  end
end
