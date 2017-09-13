class AddFieldsToTradingDocuments < ActiveRecord::Migration[5.1]
  def change
  	add_column :trading_documents, :diamond_type, :string
  	add_column :trading_documents, :source_field, :string
  	add_column :trading_documents, :box_field, :string
  	add_column :trading_documents, :cost_field, :string
  	add_column :trading_documents, :box_value_field, :string
  	add_column :trading_documents, :sight_field, :string
  	add_column :trading_documents, :price_field, :string
  end
end
