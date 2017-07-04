class AddWinnersAttachmentToTender < ActiveRecord::Migration
  def up
    add_attachment :tenders, :winner_list
  end

  def down
    remove_attachment :tenders, :winner_list
  end
end
