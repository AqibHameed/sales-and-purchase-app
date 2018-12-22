class ParcelSizeInfo < ApplicationRecord
  belongs_to :trading_parcel
  acts_as_paranoid
  validates :size, :percent, presence: true
end
