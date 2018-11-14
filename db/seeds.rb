# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


roles = ['Buyer', 'Seller', 'Supplier', 'Broker']
roles.each do |role|
  Role.create(name: role)
end

Admin.create!(email: 'admin@prismlab.co', password: 'password', password_confirmation: 'password')
# dummy_co_1 = Company.where(name: 'Dummy co. 1', county: 'India').first

dummy_co_1 = Company.create!(name: 'Dummy co. 1', county: 'India')
Company.create!(name: 'Dummy co. 2', county: 'India')
Company.create!(name: 'Dummy co. 3', county: 'India')


parcel_details = {
      company_id: dummy_co_1.id,
      credit_period: 30,
      diamond_type: 'Rough',
      description: 'Dummy Parcel for Demo',
      weight: 10,
      price: 10,
      source: 'OUTSIDE GOODS',
      box: 2,
      cost: 10,
      box_value: '12',
      sight: '07/18',
      percent: 0,
      comment: 'This is a Demo Parcel',
      total_value: 100,
      sale_demanded: true
    }
trading_parcel = TradingParcel.new(parcel_details)
trading_parcel.save(:validate => false)