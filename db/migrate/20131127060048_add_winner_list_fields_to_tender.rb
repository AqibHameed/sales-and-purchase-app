class AddWinnerListFieldsToTender < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :winner_lot_no_field,:string
    add_column :tenders, :winner_desc_field, :string
    add_column :tenders, :winner_no_of_stones_field,:string
    add_column :tenders, :winner_weight_field,:string
    add_column :tenders, :winner_selling_price_field,:string
    add_column :tenders, :winner_carat_selling_price_field,:string
    add_column :tenders, :winner_sheet_no,:integer
  end


end