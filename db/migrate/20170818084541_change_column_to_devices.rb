class ChangeColumnToDevices < ActiveRecord::Migration[5.1]
  def change
  	rename_column :devices, :type, :device_type
  end
end
