class AddAttachmentsColumnsToTenders < ActiveRecord::Migration[5.1]
  def up
    add_attachment :tenders, :document
  end

  def down
    remove_attachment :tenders, :document
  end
end

