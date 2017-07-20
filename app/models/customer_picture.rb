class CustomerPicture < ApplicationRecord
  belongs_to :customer
  belongs_to :tender
  belongs_to :stone

  validates :picture, presence: true
  has_attached_file :picture
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  rails_admin do
    list do
      [:customer, :tender, :stone, :picture, :created_at].each do |field_name|
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
      field :picture
    end
  end
end
