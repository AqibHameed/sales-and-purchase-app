require 'csv'
namespace :import_russian_csv do
  task :create_russian => :environment do
    demand_supplier = DemandSupplier.find_by(name: "RUSSIAN")
    csv = CSV.foreach(Rails.root.join('lib/tasks/russian.csv')).map { |row| row[0] }
    csv.each do |row|
      DemandList.find_or_create_by(demand_supplier_id:  demand_supplier.id, description: row)
    end
  end
end

namespace :import_dtc_csv do
  task :create_dtc => :environment do
    demand_supplier = DemandSupplier.find_by(name: "DTC")
    csv = CSV.foreach(Rails.root.join('lib/tasks/dtc.csv')).map { |row| row[0] }
    csv.each do |row|
      DemandList.find_or_create_by(demand_supplier_id:  demand_supplier.id, description: row)
    end
  end
end