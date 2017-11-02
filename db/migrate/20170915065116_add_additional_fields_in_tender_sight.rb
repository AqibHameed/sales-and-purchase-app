class AddAdditionalFieldsInTenderSight < ActiveRecord::Migration[5.1]
  def up
 	add_column :tenders,:s_no_field,:string
 	add_column :tenders,:source_no_field,:string
 	add_column :tenders,:box_no_field,:string
 	add_column :tenders,:carats_no_field,:string
 	add_column :tenders,:cost_no_field,:string
 	add_column :tenders,:boxvalue_no_field,:string
 	add_column :tenders,:sight_no_field,:string
 	add_column :tenders,:price_no_field,:string
 	add_column :tenders,:credit_no_field,:string
  end
  def down
  end
end



