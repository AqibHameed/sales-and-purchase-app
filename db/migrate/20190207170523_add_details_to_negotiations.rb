class AddDetailsToNegotiations < ActiveRecord::Migration[5.1]
  def change
    add_column :negotiations, :description, :string
    add_column :negotiations, :source, :string
  end
end
