class CreateTradingDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :trading_documents do |t|
      t.attachment :document
      t.string :credit_field
      t.string :lot_no_field
      t.string :desc_field
      t.string :no_of_stones_field
      t.string :weight_field
      t.integer :sheet_no
      t.references :customer
      t.timestamps
    end
  end
end