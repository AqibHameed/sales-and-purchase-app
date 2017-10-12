class AddAttachmentCertificateToCustomers < ActiveRecord::Migration[5.1]
  def self.up
    change_table :customers do |t|
      t.attachment :certificate
    end
  end

  def self.down
    remove_attachment :customers, :certificate
  end
end
