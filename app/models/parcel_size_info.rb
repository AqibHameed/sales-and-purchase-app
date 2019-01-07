class ParcelSizeInfo < ApplicationRecord
  belongs_to :trading_parcel
  acts_as_paranoid
  validates :percent, numericality: { only_integer: true }
  validates :size, :percent, presence: true

  validate :validate_percent

  def validate_percent
     if self.percent < 0
       self.errors.add :base, "percent value should be integer"
     end
  end
end
