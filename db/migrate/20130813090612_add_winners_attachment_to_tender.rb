class AddWinnersAttachmentToTender < ActiveRecord::Migration[5.1]
  def up
    add_attachment :tenders, :winner_list
  end

  def down
    remove_attachment :tenders, :winner_list
  end
end
