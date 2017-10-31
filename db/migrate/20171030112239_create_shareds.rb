class CreateShareds < ActiveRecord::Migration[5.1]
  def change
    create_table :shareds do |t|
    	t.references :shared_to
    	t.references :shared_by

      t.timestamps
    end
  end
end
