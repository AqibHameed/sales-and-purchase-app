class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.string :type
      t.text :content

      t.timestamps
    end
  end
end
