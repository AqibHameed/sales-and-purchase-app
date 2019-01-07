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

namespace :import_outside_csv do
  task :outside_dtc => :environment do
    outside = DemandSupplier.find_by(name: "OUTSIDE")
    csv = CSV.foreach(Rails.root.join('lib/tasks/outside.csv')).map { |row| row[0] }
    csv.each do |row|
      DemandList.find_or_create_by(demand_supplier_id:  outside.id, description: row)
    end
  end
end

namespace :import_special_csv do
  task :special_dtc => :environment do
    special = DemandSupplier.find_by(name: "SPECIAL")
    csv = CSV.foreach(Rails.root.join('lib/tasks/special.csv')).map { |row| row[0] }
    csv.each do |row|
      DemandList.find_or_create_by(demand_supplier_id:  special.id, description: row)
    end
  end
end