class AddStartingPriceFieldsToTender < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :sight_starting_price_field, :string
    add_column :tenders, :stone_starting_price_field, :string
  end
end
