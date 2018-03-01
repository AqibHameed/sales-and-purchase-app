class Notification < ApplicationRecord
  has_many :customer_notifications


  def self.send_android_notifications(registration_ids, message, supplier_name, tender_name, dates, id)
    fcm = FCM.new(ENV['FCM_KEY'])
    options = { data: { message: message, supplier_name: supplier_name, tender_name: tender_name, dates: dates, tender_id: id }, collapse_key: "IDT" }
    response = fcm.send(registration_ids, options)
  end

  def self.send_ios_notifications(registration_ids, message, id)
    apn = Houston::Client.development
    apn.certificate = File.open(Rails.root.join("config/pushcert.pem")).read
    apn.passphrase = ENV['APN_PASSWORD']

    notification = Houston::Notification.new(device: registration_ids)
    notification.alert = message
    notification.badge = 1
    # notification.sound = "sosumi.aiff"
    notification.category = "Test Category"
    notification.content_available = true
    notification.custom_data = "custom_data"
    apn.push(notification)
    puts "Error: #{notification.error}." if notification.error
  end
end
