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

  def send_feedback(star, comment)
    @email = 'contact@safetrade.ai'
    @star = star
    @comment = comment
    mail(:to => @email, :subject => '[SafeTrade] You have a feedback')
  end
end
