class PremissionRequest < ApplicationRecord
  belongs_to :sender, class_name: 'Company', foreign_key: 'sender_id', optional: true
  belongs_to :receiver, class_name: 'Company', foreign_key: 'receiver_id', optional: true
  has_one :message
  enum status: [:rejected, :accepted, :pending]
end
