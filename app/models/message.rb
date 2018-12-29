class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Company', foreign_key: 'sender_id', optional: true
  belongs_to :receiver, class_name: 'Company', foreign_key: 'receiver_id', optional: true
  belongs_to :proposal, optional: true

  scope :customer_messages, ->(current_company_id) {joins(:sender).order("created_at desc").where(receiver_id: current_company_id, message_type: "Proposal")}

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

  def self.create_new_seller(request, current_company)
    @message  = "A new seller sent you a request. Please #{ApplicationController.helpers.view_request} to accept"
    Message.create(subject: "You have a new seller request", message: @message, sender_id: request.seller_id, receiver_id: request.broker_id, message_type: "seller Request")
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

  def self.buyer_accept_proposal(proposal, current_company)
    Message.create(subject: "Buyer accepted your negotiated proposal.", message: @message, sender_id: proposal.buyer_id , receiver_id: proposal.seller_id, message_type: "Proposal", proposal_id: proposal.id)
  end

  def self.buyer_reject_proposal(proposal, current_company)
    Message.create(subject: "Buyer rejected your negotiated proposal.", message: @message, sender_id: proposal.buyer_id , receiver_id: proposal.seller_id, message_type: "Proposal", proposal_id: proposal.id)
  end

  def self.request_limit_increase(parcel, current_company)
    @message = "A new limit increase request sent to you. Please #{ApplicationController.helpers.view_limit_increase_accept(parcel, current_company)} to accept, #{ApplicationController.helpers.view_limit_increase_reject(parcel, current_company)} to reject"
    Message.create(subject: "You have a new limit increase request.", message: @message, sender_id: current_company.id , receiver_id: parcel.company_id, message_type: "Limit Increase Request", proposal_id: parcel.id)
  end

  def self.accept_limit_increase(buyer_id, parcel)
    @message = "Limit is increased successfully."
    Message.create(subject: "You have a new limit increase accept.", message: @message, sender_id: parcel.company_id, receiver_id: buyer_id, message_type: "Limit Increase Accept", proposal_id: parcel.id)
  end

  def self.reject_limit_increase(buyer_id, parcel)
    @message = "Limit request is rejected."
    Message.create(subject: "You have a new limit increase reject.", message: @message, sender_id: parcel.company_id, receiver_id: buyer_id, message_type: "Limit Increase Reject", proposal_id: parcel.id)
  end

  def self.check_parcel_request(sender_id, parcel)
    last_message = Message.where(sender_id: sender_id, receiver_id: parcel.company.id, proposal_id: parcel.id).where(message_type: 'Limit Increase Request').last
    status = true
    status = false unless last_message
    status = false if last_message and Message.where(sender_id: parcel.company.id, receiver_id: sender_id, proposal_id: parcel.id).where('id > ? and message_type in (?)', last_message.id, ['Limit Increase Accept', 'Limit Increase Reject']).present?
    status
  end
end
