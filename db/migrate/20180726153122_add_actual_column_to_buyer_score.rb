class AddActualColumnToBuyerScore < ActiveRecord::Migration[5.1]
  def change
    add_column :buyer_scores, :actual, :boolean, null: false, default: 0
  end
end
