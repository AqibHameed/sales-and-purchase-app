class AddTypeToRating < ActiveRecord::Migration[5.1]
  def change
    add_column :ratings, :flag_type, :string, :default => 'Imp'
  end
end