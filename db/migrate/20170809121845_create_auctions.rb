class CreateAuctions < ActiveRecord::Migration[5.1]
  def change
    create_table :auctions do |t|
      t.datetime :time
      t.float :min_bid
      t.integer :tender_id

      t.timestamps
    end
  end
end
