class SecureCenterJob < ActiveJob::Base
  queue_as :default

  def perform(object)
    object.secure_center
  end
end
