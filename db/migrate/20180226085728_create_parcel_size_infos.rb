class CreateParcelSizeInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :parcel_size_infos do |t|
      t.string :carats
      t.string :size
      t.string :percent
      t.integer :trading_parcel_id
      t.timestamps
    end
  end
end
