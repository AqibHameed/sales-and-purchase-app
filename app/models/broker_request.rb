class BrokerRequest < ApplicationRecord
  belongs_to :broker, class_name: 'Company', foreign_key: 'broker_id'
  belongs_to :seller, class_name: 'Company', foreign_key: 'seller_id'
  belongs_to :sender, class_name: 'Company', foreign_key: 'sender_id', optional: true
  belongs_to :receiver, class_name: 'Company', foreign_key: 'receiver_id', optional: true
end
