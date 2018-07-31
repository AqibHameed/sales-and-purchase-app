class AddActualColumnToSellerScore < ActiveRecord::Migration[5.1]
  def change
    add_column :seller_scores, :actual, :boolean, null: false, default: 0
  end
end
