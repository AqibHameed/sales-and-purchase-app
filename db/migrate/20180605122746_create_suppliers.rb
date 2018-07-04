class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :address
      t.string :country
      t.string :email
      t.string :registration_vat_no
      t.string :registration_no
      t.string :fax
      t.string :telephone
      t.string :mobile
      t.string :status
      t.integer :credit_limit
      t.integer :market_limit
      t.timestamps
    end
  end
end
