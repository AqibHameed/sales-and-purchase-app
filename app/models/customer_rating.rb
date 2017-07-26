class CustomerRating < ApplicationRecord
  belongs_to :customer
  belongs_to :tender
  belongs_to :stone

  validates_uniqueness_of :tender_id, { scope: [:customer_id], message: "and customer combination already exists." }
  validates :star, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  rails_admin do
    list do
      [:customer, :tender, :stone, :star, :created_at].each do |field_name|
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
      field :star
    end
  end
end
