class ChangeParcelColumnDatatypeInTradingParcel < ActiveRecord::Migration[5.1]
  def change
    change_column :trading_parcels, :cost, :double, default: nil
  rescue
    puts "Error In migrtion Please check "
  end
end
