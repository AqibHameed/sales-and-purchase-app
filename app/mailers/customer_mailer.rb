class CustomerMailer < ApplicationMailer
  default from: "Dialuck Admin <admin@dialuck.net>"

  def remove_broker_mail(request)
    @request = request
    broker = @request.broker.email
    mail(:to => broker, :subject => '[Dialuck] Broker Remove' )
  end

  def broker_invite_email(broker_invite)
  	@details = broker_invite
  	mail(:to => @details.email, :subject => '[Dialuck] Invitation to join Dialuck' )
  end
end