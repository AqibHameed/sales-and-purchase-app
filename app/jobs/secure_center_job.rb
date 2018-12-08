class SecureCenterJob < ActiveJob::Base
  queue_as :default

  def perform(object)
    object.delay.secure_center
  end
end
