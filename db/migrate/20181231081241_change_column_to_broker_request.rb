class ChangeColumnToBrokerRequest < ActiveRecord::Migration[5.1]
  def change
    remove_column :broker_requests, :send
    remove_column :broker_requests, :receive
    add_column :broker_requests, :sender_id, :integer
    add_column :broker_requests, :receiver_id, :integer
  end
end
