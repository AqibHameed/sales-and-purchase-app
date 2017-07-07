class AddTempDocumentToTender < ActiveRecord::Migration[5.1]
  def change
    add_attachment :tenders, :temp_document
  end
end
