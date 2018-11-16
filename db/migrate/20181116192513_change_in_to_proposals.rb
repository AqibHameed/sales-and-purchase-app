class ChangeInToProposals < ActiveRecord::Migration[5.1]
  def change
    change_column_default :proposals, :status,  4
  end
end
