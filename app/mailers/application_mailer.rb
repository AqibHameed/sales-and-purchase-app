class ApplicationMailer < ActionMailer::Base
  include SendGrid
  default from: 'SafeTrade Team <contact@safetrade.ai>'
  layout 'mailer'
end