class CreatePreRegistrationDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :pre_registration_documents do |t|
      t.attachment :document
      t.timestamps
    end
  end
end
