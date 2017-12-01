class ChangeYesNoDefaultOfBuyerLeft < ActiveRecord::Migration[5.1]
  def change
  	change_column :yes_no_buyer_interests, :buyer_left, :boolean, :default => true
  end
end
