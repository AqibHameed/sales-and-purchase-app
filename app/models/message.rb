class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Customer', foreign_key: 'sender_id', optional: true
  belongs_to :receiver, class_name: 'Customer', foreign_key: 'receiver_id', optional: true

  def self.create_message(transaction)
    message = Message.create(subject: "Reject Transaction", message: transaction.reject_reason, sender_id: transaction.buyer_id, receiver_id: transaction.supplier_id, message_type: "Reject")
  end

  def self.create_new(proposal)

    Message.create(subject: "You have a new proposal", message: "proposal is sent", sender_id: proposal.buyer_id , receiver_id: proposal.supplier_id, message_type: "Proposal")
  end
end
