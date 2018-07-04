class ApplicationMailer < ActionMailer::Base
  include SendGrid
  default from: 'ClarityNetwork <admin@dialuck.net>'
  layout 'mailer'
end