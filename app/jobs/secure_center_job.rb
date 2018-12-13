class SecureCenterJob < ActiveJob::Base
  queue_as :default
  include LiveMonitor

  def perform_now
    SecureCenter.all.each do |secure_center|
      buyer = Company.find_by(id: secure_center.buyer_id)
      seller = Company.find_by(id: secure_center.seller_id)
      create_or_update_secure_center(secure_center, buyer, seller)
    end
  end
end
