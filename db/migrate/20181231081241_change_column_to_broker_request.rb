class ChangeColumnToBrokerRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :broker_requests, :sender_id, :integer
    add_column :broker_requests, :receiver_id, :integer
  end
end
