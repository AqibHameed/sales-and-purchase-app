class AddColumnsToTables < ActiveRecord::Migration[5.1]
  def change
  	add_reference :customer_ratings, :stone
  	add_reference :customer_comments, :stone
  	add_reference :customer_pictures, :stone
  end
end
