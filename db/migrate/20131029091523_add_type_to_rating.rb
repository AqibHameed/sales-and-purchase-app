class AddTypeToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :flag_type, :string, :default => 'Imp'
  end
end