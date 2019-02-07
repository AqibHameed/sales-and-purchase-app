class ChangeRankToBeIntegerInRanks < ActiveRecord::Migration[5.1]
  def self.up
    change_column :ranks, :rank, :integer
  end

  def self.down
    change_column :ranks, :rank, :string
  end
end
