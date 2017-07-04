class AddSendConfirmationToTenders < ActiveRecord::Migration
  def up
    add_column :tenders, :send_confirmation, :boolean
  end

  def down
    remove_column :tenders, :send_confirmation
  end
end

