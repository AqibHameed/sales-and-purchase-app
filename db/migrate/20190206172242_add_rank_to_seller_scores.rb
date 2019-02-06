class AddRankToSellerScores < ActiveRecord::Migration[5.1]
  def change
    add_column :seller_scores, :rank, :integer
  end
end
