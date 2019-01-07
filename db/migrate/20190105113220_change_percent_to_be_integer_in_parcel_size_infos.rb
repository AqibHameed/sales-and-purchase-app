class ChangePercentToBeIntegerInParcelSizeInfos < ActiveRecord::Migration[5.1]
  def self.up
    change_column :parcel_size_infos, :percent, :integer
  end

  def self.down
    change_column :parcel_size_infos, :percent, :string
  end
end
