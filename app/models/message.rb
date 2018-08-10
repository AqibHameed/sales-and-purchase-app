class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Company', foreign_key: 'sender_id', optional: true
  belongs_to :receiver, class_name: 'Company', foreign_key: 'receiver_id', optional: true
  belongs_to :proposal
  def self.create_message(transaction)
    message = Message.create(subject: "Reject Transaction", message: transaction.reject_reason, sender_id: transaction.buyer_id, receiver_id: transaction.seller_id, message_type: "Reject")
  end

  def self.create_new(proposal)
    @message  = "#{proposal.notes} </br>"
    @message << "For more Details about proposal, #{ApplicationController.helpers.view_proposal(proposal)}"

    Message.create(subject: "You have a new proposal", message: @message, sender_id: proposal.buyer_id , receiver_id: proposal.seller_id, message_type: "Proposal", proposal_id: proposal.id)
  end

  def self.create_new_message(proposal, current_company)
    @message  = "#{proposal.notes} </br>"
    @message << "#{ApplicationController.helpers.view_proposal_details(proposal, current_company)}"

    Message.create(subject: "You have a new proposal", message: @message, sender_id: proposal.buyer_id , receiver_id: proposal.seller_id, message_type: "Proposal", proposal_id: proposal.id)
  end

  def self.create_new_negotiate(proposal, current_company)
    @message  = "#{proposal.notes} </br>"
    @message << "For more Details about proposal, #{ApplicationController.helpers.view_proposal(proposal)}"
    if current_company.id == proposal.seller_id
      Message.create(subject: "Seller sent a new proposal.", message: @message, sender_id: proposal.seller_id, receiver_id: proposal.buyer_id, message_type: "Proposal", proposal_id: proposal.id)
    else
      Message.create(subject: "Buyer sent a new proposal.", message: @message, sender_id: proposal.buyer_id, receiver_id: proposal.seller_id, message_type: "Proposal", proposal_id: proposal.id)
    end
  end

  def self.create_new_broker(request, current_company)
    @message  = "A new broker sent you a request. Please #{ApplicationController.helpers.view_request} to accept"
    Message.create(subject: "You have a new broker request", message: @message, sender_id: request.broker_id, receiver_id: request.seller_id, message_type: "Broker Request")
  end

  def self.create_new_credit_request(current_company)
    @message  = "A new credit request sent to you. Please #{ApplicationController.helpers.view_confirm_request} to accept"
    Message.create(subject: "You have a new credit request", message: @message, sender_id: current_company.id, receiver_id: current_company.parent_id, message_type: "Credit Request")
  end

  def self.accept_proposal(proposal, current_company)
    @message = "The deal is accepted."
    Message.create(subject: "Your proposal is accepted.", message: @message, sender_id: proposal.seller_id , receiver_id: proposal.buyer_id, message_type: "Proposal", proposal_id: proposal.id)
  end

  def self.reject_proposal(proposal, current_company)
    @message = "The deal is rejected."
    Message.create(subject: "Your proposal is rejected.", message: @message, sender_id: proposal.seller_id , receiver_id: proposal.buyer_id, message_type: "Proposal", proposal_id: proposal.id)
  end

end
