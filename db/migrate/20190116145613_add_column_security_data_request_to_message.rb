class AddColumnSecurityDataRequestToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :live_monitoring_request_id, :integer
  end
end
