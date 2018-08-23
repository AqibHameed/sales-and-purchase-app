class AddColumsToProposals < ActiveRecord::Migration[5.1]
  def change
    add_column :proposals, :negotiated, :boolean, :default => false
  end
end
