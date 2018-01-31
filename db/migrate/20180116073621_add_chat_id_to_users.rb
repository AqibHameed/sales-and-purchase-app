class AddChatIdToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :customers, :chat_id, :string, default: '-1'
  end
end
