class ChangeColumnDefaultToTender < ActiveRecord::Migration[5.1]
  def change
    change_column :tenders, :tender_type, :string, null:false, default: ""
  end
end
