class BrokerInvite < ApplicationRecord
  validates :email, presence: true
  validate :check_email_exists

  def check_email_exists
    customer = Customer.where(email: email).first
    if customer.nil?
      # Do Nothing
    else
      errors[:base] << "Person already exist."
    end
  end
end
