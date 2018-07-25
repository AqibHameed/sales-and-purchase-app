class RemoveColumnSizeInPolishedDemands < ActiveRecord::Migration[5.1]
  def change
  	remove_column :polished_demands, :size
  end
end
