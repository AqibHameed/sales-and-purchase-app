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

Company.create!(name: 'Dummy co. 1', county: 'India')
Company.create!(name: 'Dummy co. 2', county: 'India')
Company.create!(name: 'Dummy co. 3', county: 'India')