class StoneDetail < ApplicationRecord
  belongs_to :stone
  belongs_to :customer
  belongs_to :tender

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_attached_file :file,  default_url: "/images/:style/missing.png"

end
