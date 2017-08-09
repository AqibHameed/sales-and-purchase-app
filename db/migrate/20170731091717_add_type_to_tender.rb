class AddTypeToTender < ActiveRecord::Migration[5.1]
  def change
    add_column :tenders, :tender_type, :string, null:false, default: "Blind"
  end
end
