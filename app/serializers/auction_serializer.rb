class AuctionSerializer < ActiveModel::Serializer
  attributes :id, :time, :min_bid, :tender_id
end
