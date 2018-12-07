require 'csv'
namespace :import_incidents_csv do
  task :create_incidents => :environment do
    demand_supplier = DemandSupplier.find_by(name: "Russian")
    csv_text = File.read('...')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|

      DemandList.create!(demand_supplier_id:  demand_supplier.id, description: row.to_hash)
    end
  end
end