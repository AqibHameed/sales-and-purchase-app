class DropLiveMonitoringRequestsTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :live_monitoring_requests
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
