class ChangeRankTypeInBuyerScores < ActiveRecord::Migration[5.1]
  def self.up
    change_column :buyer_scores, :late_payment_rank, :integer
    change_column :buyer_scores, :current_risk_rank, :integer
    change_column :buyer_scores, :network_diversity_rank, :integer
    change_column :buyer_scores, :buyer_network_rank, :integer
    change_column :buyer_scores, :due_date_rank, :integer
    change_column :buyer_scores, :credit_used_rank, :integer
    change_column :buyer_scores, :count_of_credit_given_rank, :integer
  end

  def self.down
    change_column :buyer_scores, :late_payment_rank, :string
    change_column :buyer_scores, :current_risk_rank, :string
    change_column :buyer_scores, :network_diversity_rank, :string
    change_column :buyer_scores, :buyer_network_rank, :string
    change_column :buyer_scores, :due_date_rank, :string
    change_column :buyer_scores, :credit_used_rank, :string
    change_column :buyer_scores, :count_of_credit_given_rank, :string
  end
end
