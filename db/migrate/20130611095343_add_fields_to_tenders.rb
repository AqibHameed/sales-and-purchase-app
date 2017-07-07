class AddFieldsToTenders < ActiveRecord::Migration[5.1]
  def up
    add_column :tenders, :no_of_stones, :integer
    add_column :tenders, :weight, :float
    add_column :tenders, :carat, :float
    add_column :tenders, :color, :string
    add_column :tenders, :purity, :float
    add_column :tenders, :polished, :boolean
    add_column :tenders, :type, :string
    add_column :tenders, :size, :string
  end

  def down
    remove_column :tenders, :no_of_stones
    remove_column :tenders, :weight
    remove_column :tenders, :carat
    remove_column :tenders, :color
    remove_column :tenders, :purity
    remove_column :tenders, :polished
    remove_column :tenders, :type
    remove_column :tenders, :size
  end
end

