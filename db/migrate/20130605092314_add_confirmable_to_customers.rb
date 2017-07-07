class AddConfirmableToCustomers < ActiveRecord::Migration[5.1]
  def up
    change_table :customers do |t|
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable
    end
  end

  def down
    [:confirmation_token, :confirmed_at, :confirmation_sent_at].each do |column_name|
      remove_column :customers, column_name
    end
  end
end

