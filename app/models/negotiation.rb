class Negotiation < ApplicationRecord
  belongs_to :proposal
  enum from: [ :buyer, :seller ]
end
