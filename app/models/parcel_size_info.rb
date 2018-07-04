class ParcelSizeInfo < ApplicationRecord
  belongs_to :trading_parcel

  validates :size, :percent, presence: true
end
