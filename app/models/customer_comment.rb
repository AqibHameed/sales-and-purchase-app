class CustomerComment < ApplicationRecord
  belongs_to :customer
  belongs_to :tender

  validates :description, presence: true

  rails_admin do
    list do
      [:customer, :tender, :description, :created_at].each do |field_name|
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
      field :description
    end
  end
end
