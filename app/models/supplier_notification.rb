class SupplierNotification < ApplicationRecord
  validates_presence_of :supplier_id
  belongs_to :supplier
  belongs_to :customer
end