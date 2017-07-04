class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.float :amount
      t.text :message
      t.datetime :bid_date
      t.references :tender
      t.references :customer

      t.timestamps
    end
  end
end

