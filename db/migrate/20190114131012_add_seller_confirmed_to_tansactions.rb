class AddSellerConfirmedToTansactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :seller_confirmed, :boolean, default: false
  end
end
