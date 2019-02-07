class AddAttachmentImageToStoneDetails < ActiveRecord::Migration[5.1]
  def self.up
    change_table :stone_details do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :stone_details, :image
  end
end
