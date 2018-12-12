class SecureCenterJob < ActiveJob::Base
  queue_as :default

  def perform
    SecureCenter.all.each do |secure_center|
      create_or_update_secure_center(secure_center, secure_center.buyer, secure_center.seller)
    end
  end
end
