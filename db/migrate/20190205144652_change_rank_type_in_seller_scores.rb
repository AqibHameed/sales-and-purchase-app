class ChangeRankTypeInSellerScores < ActiveRecord::Migration[5.1]
  def self.up
    change_column :seller_scores, :seller_late_payment_rank, :integer
    change_column :seller_scores, :seller_current_risk_rank, :integer
    change_column :seller_scores, :seller_network_diversity_rank, :integer
    change_column :seller_scores, :seller_network_rank, :integer
    change_column :seller_scores, :seller_due_date_rank, :integer
    change_column :seller_scores, :seller_credit_used_rank, :integer
  end

  def self.down
    change_column :seller_scores, :seller_late_payment_rank, :string
    change_column :seller_scores, :seller_current_risk_rank, :string
    change_column :seller_scores, :seller_network_diversity_rank, :string
    change_column :seller_scores, :seller_network_rank, :string
    change_column :seller_scores, :seller_due_date_rank, :string
    change_column :seller_scores, :seller_credit_used_rank, :string
  end
end
