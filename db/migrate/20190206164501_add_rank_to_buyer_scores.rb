class AddRankToBuyerScores < ActiveRecord::Migration[5.1]
  def change
    add_column :buyer_scores, :rank, :integer
  end
end
