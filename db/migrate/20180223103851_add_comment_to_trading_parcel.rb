class AddCommentToTradingParcel < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_parcels, :comment, :text
  end
end
