class AddColumnToEmailAttachments < ActiveRecord::Migration[5.1]
  def change
  	add_column :email_attachments, :tender_id, :integer
  end
end
