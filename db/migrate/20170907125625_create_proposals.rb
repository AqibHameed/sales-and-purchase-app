class CreateProposals < ActiveRecord::Migration[5.1]
  def change
    create_table :proposals do |t|
      t.integer :buyer_id
      t.integer :supplier_id
      t.integer :trading_parcel_id
      t.decimal :price
      t.integer :credit
      t.text  :notes
      t.integer :status, default: 0
      t.integer :action_for
      t.timestamps
    end
  end
end
