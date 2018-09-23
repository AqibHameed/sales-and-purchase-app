class Negotiation < ApplicationRecord
  belongs_to :proposal
  enum from: [ :buyer, :seller ]

  def whose
  	if from == 'seller'
      proposal.seller
    elsif from == 'buyer'
      proposal.buyer
    end
  end
end
