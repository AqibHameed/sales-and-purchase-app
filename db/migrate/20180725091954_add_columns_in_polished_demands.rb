class AddColumnsInPolishedDemands < ActiveRecord::Migration[5.1]
  def change
  	rename_column :polished_demands, :weight, :weight_from
  	add_column :polished_demands, :weight_to, :integer
  	rename_column :polished_demands, :color, :color_from
  	add_column :polished_demands, :color_to, :string
  	rename_column :polished_demands, :clarity, :clarity_from
  	add_column :polished_demands, :clarity_to, :string
  	rename_column :polished_demands, :cut, :cut_from
  	add_column :polished_demands, :cut_to, :string
  	rename_column :polished_demands, :polish, :polish_from
  	add_column :polished_demands, :polish_to, :string
  	rename_column :polished_demands, :symmetry, :symmetry_from
  	add_column :polished_demands, :symmetry_to, :string
  	rename_column :polished_demands, :fluorescence, :fluorescence_from
  	add_column :polished_demands, :fluorescence_to, :string
  end
end
