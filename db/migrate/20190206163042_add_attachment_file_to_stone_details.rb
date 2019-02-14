class AddAttachmentFileToStoneDetails < ActiveRecord::Migration[5.1]
  def self.up
    change_table :stone_details do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :stone_details, :file
  end
end
