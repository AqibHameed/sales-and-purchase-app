class CustomerMailer < ApplicationMailer
  default from: "Dialuck Admin <admin@dialuck.net>"

  def remove_broker_mail(request)
    @request = request
    broker = request.broker.email
    mail(:to => broker, :subject => '[Dialuck] Broker Remove' )
  end
end