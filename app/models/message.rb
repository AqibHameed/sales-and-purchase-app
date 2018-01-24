class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Customer', foreign_key: 'sender_id', optional: true
  belongs_to :receiver, class_name: 'Customer', foreign_key: 'receiver_id', optional: true

  def self.create_message(transaction)
    message = Message.create(subject: "Reject Transaction", message: transaction.reject_reason, sender_id: transaction.buyer_id, receiver_id: transaction.supplier_id, message_type: "Reject")
  end

  def self.create_new(proposal)
    @message  = "#{proposal.notes} </br>"
    @message << "For more Details about proposal, #{ApplicationController.helpers.view_proposal(proposal)}"

    Message.create(subject: "You have a new proposal", message: @message, sender_id: proposal.buyer_id , receiver_id: proposal.supplier_id, message_type: "Proposal")
  end

  def self.create_new_negotiate(proposal, current_customer)
    @message  = "#{proposal.notes} </br>"
    @message << "For more Details about proposal, #{ApplicationController.helpers.view_proposal(proposal)}"
    if current_customer.id == proposal.supplier_id
      Message.create(subject: "Seller sent a new proposal.", message: @message, sender_id: proposal.supplier_id, receiver_id: proposal.buyer_id, message_type: "Proposal")
    else
      Message.create(subject: "Buyer sent a new proposal.", message: @message, sender_id: proposal.buyer_id, receiver_id: proposal.supplier_id, message_type: "Proposal")
    end
  end

  def self.create_new_broker(request, current_customer)
    @message  = "A new broker sent you a request. Please #{ApplicationController.helpers.view_request} to accept"
    Message.create(subject: "You have a new broker request", message: @message, sender_id: request.broker_id, receiver_id: request.seller_id, message_type: "Broker Request")
  end
end
