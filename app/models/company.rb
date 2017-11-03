class Company < ApplicationRecord
  # attr_accessible :name, :address, :country, :email, :registration_vat_no, :registration_no, :fax, :telephone, :mobile, :contact_person_ids
  has_many :sub_companies, :class_name => 'Company', :foreign_key => :parent_id
  belongs_to :parent, :class_name => 'Company', :foreign_key => :parent_id, optional: true

  has_many :contact_people
  has_many :tenders
  has_many :trading_parcels
  has_many :supplier_notifications, :class_name => 'SupplierNotification', :foreign_key => :supplier_id
  has_many :supplier_mines

  belongs_to :customer, optional: true

  validates_presence_of :name
  validates_uniqueness_of :name

  accepts_nested_attributes_for :contact_people
  accepts_nested_attributes_for :sub_companies, :allow_destroy => true

  rails_admin do
    label "Suppliers"
    edit do
       [:name, :address, :country, :email, :registration_vat_no, :registration_no, :fax, :telephone, :mobile].each do |field_name|
        field field_name
      end
      field :contact_people  do
        label "Contact Peoples"
        nested_form false
        associated_collection_scope do
          Proc.new { |scope|
            scope = scope.includes(:company)
          }
        end
      end
    end
  end
end
