class ParcelImage < ApplicationRecord
  belongs_to :parcel, class_name: 'Stone', foreign_key: 'parcel_id'
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
