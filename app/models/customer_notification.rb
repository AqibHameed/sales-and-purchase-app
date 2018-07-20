class CustomerNotification < ApplicationRecord
  belongs_to :notification
  belongs_to :customer

  def self.add_notification_history(android_devices, ios_devices, notification)
    ios_users = ios_devices.uniq {|t| t.customer_id }
    android_users = android_devices.uniq {|t| t.customer_id }
    all_users = ios_users + android_users
    data = all_users.map { |e| { notification_id: notification.id, customer_id: e.customer_id }}
    CustomerNotification.create(data) unless data.empty?
  end
end
