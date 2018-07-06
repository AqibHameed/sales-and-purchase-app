class BrokerRequest < ApplicationRecord
  belongs_to :broker, class_name: 'Customer', foreign_key: 'broker_id'
  belongs_to :seller, class_name: 'Customer', foreign_key: 'seller_id'
end
