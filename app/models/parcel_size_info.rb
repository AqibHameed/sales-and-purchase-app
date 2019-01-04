class ParcelSizeInfo < ApplicationRecord
  belongs_to :trading_parcel
  acts_as_paranoid
  validates :size, numericality: { only_integer: true }
  validates :size, :percent, presence: true
end
