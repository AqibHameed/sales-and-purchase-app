class CustomerMailer < ApplicationMailer
  default from: "ClarityNetwork <admin@dialuck.net>"

  def remove_broker_mail(request)
    @request = request
    broker = @request.try(:broker).try(:customers).try(:first).try(:email)
    mail(:to => broker, :subject => '[ClarityNetwork] Broker Remove' )
  end

  def broker_invite_email(broker_invite)
  	@details = broker_invite
  	mail(:to => @details.email, :subject => '[ClarityNetwork] Invitation to join Dialuck' )
  end

  def approve_access(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[ClarityNetwork] Your access request is approved')
  end

  def remove_access(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[ClarityNetwork] Your access is removed ')
  end

  def request_access_mail(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[ClarityNetwork] You have a new access request ')
  end
end
