class CreateEmailTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :email_templates do |t|
      t.string :type_of_event
      t.string :before_here
      t.string :after_here
      t.timestamps
    end
  end
end
