class CreatePushNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :push_notifications do |t|
      t.string :type_of_event
      t.text :message
      t.timestamps
    end
  end
end
