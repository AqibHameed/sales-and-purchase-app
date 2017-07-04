ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.live.com",
  :port                 => 587,
  :domain               => 'dialuck.net',
  :user_name            => 'admin@dialuck.net',
  :password             => 'Dialuck12345678',
  :authentication       => :plain,
  :enable_starttls_auto => true  
}
# 
# 
# ActionMailer::Base.smtp_settings = {
  # :address              => "smtp.gmail.com",
  # :port                 => 587,
  # :domain               => "gmail.com",
  # :user_name            => "careers@intelliswift.co.in",
  # :password             => "intelli123",
  # :authentication       => "plain",
  # :enable_starttls_auto => true
# }

