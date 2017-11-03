class AddColumnsToSight < ActiveRecord::Migration[5.1]
  def up
    add_column :sights, :sight_reserved_price, :string
    add_column :sights, :yes_no_system_price, :float
    add_column :sights, :stone_winning_price, :float
    add_column :sights, :interest, :boolean, :default => true 
  end
  def down
    remove_column :sights, :reserved_price, :string
    remove_column :sights, :yes_no_system_price, :float
    remove_column :sights, :stone_winning_price, :float
    remove_column :sights, :interest, :boolean, :default => true
  end

end
