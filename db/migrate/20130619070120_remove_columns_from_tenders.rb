class RemoveColumnsFromTenders < ActiveRecord::Migration[5.1]
  def up
    [:no_of_stones, :weight, :carat, :color, :purity, :polished, :tender_type, :size].each do |column_name|
      remove_column :tenders, column_name
    end
  end

  def down
    add_column :tenders, :no_of_stones, :integer
    add_column :tenders, :weight, :float
    add_column :tenders, :carat, :float
    add_column :tenders, :color, :string
    add_column :tenders, :purity, :float
    add_column :tenders, :polished, :boolean
    add_column :tenders, :tender_type, :string
    add_column :tenders, :size, :string
  end
end

