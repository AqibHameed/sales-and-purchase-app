class CreateEmailAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :email_attachments do |t|
      t.attachment :file

      t.timestamps
    end
  end
end
