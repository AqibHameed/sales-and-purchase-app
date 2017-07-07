class CreateNews < ActiveRecord::Migration[5.1]
  def change
    create_table :news do |t|
      t.string :title
      t.text :url
      t.datetime :date
      t.string :category
      t.text :description
      t.boolean :status

      t.timestamps
    end
  end
end

