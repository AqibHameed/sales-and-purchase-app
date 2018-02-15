class CreateBrokerInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :broker_invites do |t|
      t.string :email
      t.integer :customer_id
      t.timestamps
    end
  end
end
