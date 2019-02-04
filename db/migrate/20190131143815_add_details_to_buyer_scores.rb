class AddDetailsToBuyerScores < ActiveRecord::Migration[5.1]
  def change
    add_column :buyer_scores, :late_payment_rank, :string
    add_column :buyer_scores, :current_risk_rank, :string
    add_column :buyer_scores, :network_diversity_rank, :string
    add_column :buyer_scores, :buyer_network_rank, :string
    add_column :buyer_scores, :due_date_rank, :string
    add_column :buyer_scores, :credit_used_rank, :string
    add_column :buyer_scores, :count_of_credit_given_rank, :string
    add_column :buyer_scores, :late_payment_comparison, :float, null: false, default: '0.00'
    add_column :buyer_scores, :current_risk_comparison, :float, null: false, default: '0.00'
    add_column :buyer_scores, :network_diversity_comparison, :float, null: false, default: '0.00'
    add_column :buyer_scores, :buyer_network_comparison, :float, null: false, default: '0.00'
    add_column :buyer_scores, :due_date_comparison, :float, null: false, default: '0.00'
    add_column :buyer_scores, :credit_used_comparison, :float, null: false, default: '0.00'
    add_column :buyer_scores, :count_of_credit_given_comparison, :float, null: false, default: '0.00'
  end
end
