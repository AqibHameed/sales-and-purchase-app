class AddNoOfParcelsToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :no_of_parcels, :integer
  end
end
