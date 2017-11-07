class AddDoSightDocumentTenders < ActiveRecord::Migration[5.1]
  def up
    add_attachment :tenders, :sight_document
  end

  def down
    remove_attachment :tenders, :sight_document
  end
end
