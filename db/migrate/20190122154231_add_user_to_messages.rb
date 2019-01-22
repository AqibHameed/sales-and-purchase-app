class AddUserToMessages < ActiveRecord::Migration[5.1]
  def change
    add_reference :messages, :premission_request, foreign_key: true
  end
end
