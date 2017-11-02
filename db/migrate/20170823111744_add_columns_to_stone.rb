class AddColumnsToStone < ActiveRecord::Migration[5.1]
  def change
    add_column :stones, :comments, :string
    add_column :stones, :valuation, :string
    add_column :stones, :parcel_rating, :integer
  end
end
