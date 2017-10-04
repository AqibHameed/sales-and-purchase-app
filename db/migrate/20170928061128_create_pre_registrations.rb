class CreatePreRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :pre_registrations do |t|
      t.string :company_name
      t.timestamps
    end
  end
end
