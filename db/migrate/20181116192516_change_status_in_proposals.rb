class ChangeStatusInProposals < ActiveRecord::Migration[5.1]
  def change
    change_column_default :proposals, :status,  3
  end
end