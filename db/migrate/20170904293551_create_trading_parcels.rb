class CreateTradingParcels < ActiveRecord::Migration[5.1]
  def change
    create_table :trading_parcels do |t|
      t.integer :lot_no
      t.string :description
      t.integer :no_of_stones
      t.decimal :weight
      t.integer :credit_period
      t.decimal :price
      t.integer :company_id
      t.references :customer
      t.references :trading_document

      t.timestamps
    end
  end
end
