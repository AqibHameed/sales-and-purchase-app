class AddDetailsToSellerScores < ActiveRecord::Migration[5.1]
  def change
    add_column :seller_scores, :seller_late_payment_rank, :string
    add_column :seller_scores, :seller_current_risk_rank, :string
    add_column :seller_scores, :seller_network_diversity_rank, :string
    add_column :seller_scores, :seller_network_rank, :string
    add_column :seller_scores, :seller_due_date_rank, :string
    add_column :seller_scores, :seller_credit_used_rank, :string
    add_column :seller_scores, :seller_late_payment_comparison, :float, null: false, default: '0.00'
    add_column :seller_scores, :seller_current_risk_comparison, :float, null: false, default: '0.00'
    add_column :seller_scores, :seller_network_diversity_comparison, :float, null: false, default: '0.00'
    add_column :seller_scores, :seller_network_comparison, :float, null: false, default: '0.00'
    add_column :seller_scores, :seller_due_date_comparison, :float, null: false, default: '0.00'
    add_column :seller_scores, :seller_credit_used_comparison, :float, null: false, default: '0.00'
  end
end
