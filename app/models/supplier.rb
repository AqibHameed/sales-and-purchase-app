class Supplier < ApplicationRecord
  has_many :tenders
  # has_many :trading_parcels
  has_many :supplier_notifications
  has_many :supplier_mines

  validates_presence_of :name
  validates_uniqueness_of :name

  # accepts_nested_attributes_for :contact_people
  # accepts_nested_attributes_for :sub_companies, :allow_destroy => true

  rails_admin do
    label "Suppliers"
    edit do
       [:name, :address, :country, :email, :registration_vat_no, :registration_no, :fax, :telephone, :mobile].each do |field_name|
        field field_name
      end
      # field :contact_people  do
      #   label "Contact Peoples"
      #   nested_form false
      #   associated_collection_scope do
      #     Proc.new { |scope|
      #       scope = scope.includes(:company)
      #     }
      #   end
      # end
    end
  end
end
