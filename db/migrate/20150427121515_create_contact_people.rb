class CreateContactPeople < ActiveRecord::Migration
  def change
    create_table :contact_people do |t|
    	t.string   :name, :null => false
    	t.string   :designation, :null => false
    	t.integer  :company_id
      t.string   :telephone
      t.integer  :mobile
      t.string   :passport_no
    	t.string   :pio_card
      t.timestamps
    end
  end
end
