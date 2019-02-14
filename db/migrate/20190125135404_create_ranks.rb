class CreateRanks < ActiveRecord::Migration[5.1]
  def change
    create_table :ranks do |t|
      t.references :company, foreign_key: true
      t.integer :yes_know
      t.integer :not_know
      t.integer :yes_trade
      t.integer :not_trade
      t.integer :yes_recommend
      t.integer :not_recommend
      t.integer :yes_experience
      t.integer :not_experience
      t.float :total_know
      t.float :total_trade
      t.float :total_recommend
      t.float :total_experience
      t.float :total_average
      t.string :rank
      t.integer :total_number_of_comapnies_rated

      t.timestamps
    end
  end
end
