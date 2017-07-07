class AddFieldsToStones < ActiveRecord::Migration[5.1]
  def change
    add_column :stones, :deec_no, :integer
    add_column :stones, :lot_no, :integer
    add_column :stones, :description, :text
  end

  def down
    [:deec_no, :lot_no, :description].each do |column|
      remove_column :stones, column
    end
  end
end

