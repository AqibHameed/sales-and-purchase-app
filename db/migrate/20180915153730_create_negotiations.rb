class CreateNegotiations < ActiveRecord::Migration[5.1]
  def change
    create_table :negotiations do |t|
      t.references :proposal, foreign_key: true
      t.float :percent
      t.integer :credit
      t.float :price
      t.float :total_value
      t.string :comment
      t.integer :from

      t.timestamps
    end
  end
end
