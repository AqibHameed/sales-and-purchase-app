class CustomerMailer < ApplicationMailer
  default from: "SafeTrade Team <contact@safetrade.ai>"

  def remove_broker_mail(request)
    @request = request
    broker = @request.try(:broker).try(:customers).try(:first).try(:email)
    mail(:to => broker, :subject => '[SafeTrade] Broker Remove' )
  end

  def broker_invite_email(broker_invite)
  	@details = broker_invite
  	mail(:to => @details.email, :subject => '[SafeTrade] Invitation to join SafeTrade' )
  end

  def approve_access(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[SafeTrade] Your access request is approved')
  end

  def remove_access(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[SafeTrade] Your access is removed ')
  end

  def request_access_mail(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[SafeTrade] You have a new access request ')
  end

  def send_invitation(email)
    @email = email
    mail(:to => email, :subject => '[SafeTrade] You have a invitation ')
  end

  def send_feedback(name, star, comment)
    @email = 'maneetchoksi1+3yacf283ozlmnfeswtlu@boards.trello.com'
    @star = star
    @comment = comment
    @name = name
    mail(:to => @email, :subject => '[SafeTrade] You have a feedback')
  end

  def send_negotiation(proposal , receiver_emails, sender_email)
    @last_negotiated = proposal.negotiations.order('created_at ASC' ).last
    mail(:to => receiver_emails, from: sender_email, :subject => '[SafeTrade] You have a new proposal.')
  end

  def send_proposal(proposal , sender, sender_company)
    @proposal = proposal
    @sender = sender_company
    receiver_emails = proposal.seller.customers.map{|c| c.email}
    mail(:to => receiver_emails, from: sender.email, :subject => '[SafeTrade] You have a new proposal.')
  end

  def unregistered_users_mail_to_company(seller, seller_company, transaction)
    @transaction = transaction
    @seller = seller_company
    mail(to: transaction.buyer.email, from: seller.email, subject: '[SafeTrade] You have a new direct sell.')
  end

  def mail_to_registered_users(seller, seller_company, transaction)
    @transaction = transaction
    @seller = seller_company
    all_user_emails = transaction.buyer.customers.map{|c| c.email}
    mail(to: all_user_emails, from: seller.email, subject: '[SafeTrade] You have a new direct sell.')
  end
end
