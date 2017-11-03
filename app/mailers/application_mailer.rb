class ApplicationMailer < ActionMailer::Base
  include SendGrid
  default from: 'Dialuck Admin <admin@dialuck.net>'
  layout 'mailer'
end