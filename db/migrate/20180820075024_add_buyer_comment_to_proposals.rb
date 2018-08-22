class AddBuyerCommentToProposals < ActiveRecord::Migration[5.1]
  def change
    add_column :proposals, :buyer_comment, :string
  end
end
