class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :sender
      t.references :receiver
      t.string :message
      t.string :message_type
      t.string :subject
      t.timestamps
    end
  end
end
