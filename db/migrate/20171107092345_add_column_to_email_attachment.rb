class AddColumnToEmailAttachment < ActiveRecord::Migration[5.1]
  def change
  	add_column :email_attachments, :customer_id, :integer
  end
end
