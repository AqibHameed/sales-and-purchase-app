class ChangeCarat < ActiveRecord::Migration[5.1]
  def up
    change_column :stones, :carat, :decimal, :precision => 10, :scale => 5
  end

  def down
    change_column :stones, :carat, :float
  end
end
