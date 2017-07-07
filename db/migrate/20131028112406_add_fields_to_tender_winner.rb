class AddFieldsToTenderWinner < ActiveRecord::Migration[5.1]
  def change
    add_column :tender_winners, :description, :string
    add_column :tender_winners, :avg_selling_price, :float
  end
end
