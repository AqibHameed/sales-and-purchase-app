class AddColumnIntoAuction < ActiveRecord::Migration[5.1]
  def change
    add_column :auctions, :evaluating_round_id, :integer
  end
end
