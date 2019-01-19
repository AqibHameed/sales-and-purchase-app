class AddColumnCreditToSecureCenter < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_centers, :balance_credit_limit, :float, precision: 10, scale: 2
    add_column :secure_centers, :number_of_seller_offer_credit, :float, precision: 10, scale: 2
  end
end
