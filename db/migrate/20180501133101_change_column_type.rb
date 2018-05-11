class ChangeColumnType < ActiveRecord::Migration[5.1]
  def change
  	change_column :messages, :message, :text
  end
end
