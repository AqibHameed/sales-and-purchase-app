class SupplierNotification < ApplicationRecord
  validates_presence_of :supplier_id
  belongs_to :supplier, foreign_key: 'supplier_id', class_name: 'Company'
  belongs_to :customer
end