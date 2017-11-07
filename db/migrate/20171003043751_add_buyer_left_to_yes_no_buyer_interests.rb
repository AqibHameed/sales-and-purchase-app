class AddBuyerLeftToYesNoBuyerInterests < ActiveRecord::Migration[5.1]
  def change
    add_column :yes_no_buyer_interests, :buyer_left, :boolean, :default => false
  end
end
