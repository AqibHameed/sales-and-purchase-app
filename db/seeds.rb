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

Admin.create(email: 'admin@prismlab.co', password: 'password', password_confirmation: 'password')
# # dummy_co_1 = Company.where(name: 'Dummy co. 1', county: 'India').first
#
# dummy_co_1 = Company.find_or_create_by(name: 'Dummy co. 1', county: 'India')
# dummy_co_2 = Company.find_or_create_by(name: 'Dummy co. 2', county: 'India')
# dummy_co_3 = Company.find_or_create_by(name: 'Dummy co. 3', county: 'India')

# rough_parcel1 = {
#     company_id: dummy_co_2.id,
#     credit_period: 30,
#     diamond_type: 'Rough',
#     description: 'Dummy Parcel for Demo',
#     weight: 10,
#     price: 10,
#     source: DemandSupplier::OUTSIDE,
#     box: 2,
#     cost: 10,
#     box_value: '12',
#     sight: '07/18',
#     percent: 0,
#     comment: 'This is a Demo Parcel',
#     total_value: 100,
#     sale_demanded: true
# }
# rough_parcel2 = {
#     company_id: dummy_co_2.id,
#     credit_period: 30,
#     diamond_type: 'Rough',
#     description: 'Dummy Parcel for Demo',
#     weight: 10,
#     price: 10,
#     source: DemandSupplier::OUTSIDE,
#     box: 2,
#     cost: 10,
#     box_value: '12',
#     sight: '07/18',
#     percent: 0,
#     comment: 'This is a Demo Parcel',
#     total_value: 100,
#     sale_demanded: true,
#     sold: true
# }
# parcel_details = {
#       company_id: dummy_co_1.id,
#       credit_period: 30,
#       diamond_type: 'Rough',
#       description: 'Dummy Parcel for Demo',
#       weight: 10,
#       price: 10,
#       source: DemandSupplier::OUTSIDE,
#       box: 2,
#       cost: 10,
#       box_value: '12',
#       sight: '07/18',
#       percent: 0,
#       comment: 'This is a Demo Parcel',
#       total_value: 100,
#       sale_demanded: true
#     }
#
# polished_parcel = {
#     no_of_stones: 0,
#     weight: 10,
#     credit_period: 30,
#     price: 10,
#     company_id: dummy_co_2.id,
#     cost: 10,
#     box_value: '0',
#     source: DemandSupplier::POLISHED,
#     diamond_type: 'Polished',
#     sale_demanded: true,
#     percent: 0,
#     comment: 'This is Dummy Polished Parcel',
#     total_value: 240,
#     shape: 'Round',
#     color: 'M',
#     clarity: 'SI3',
#     cut: 'Good',
#     polish: 'Excellent',
#     symmetry: 'Excellent',
#     fluorescence: 'None',
#     lab: 'GCAL',
#     city: 'Kabul',
#     country: 'Afghanistan'
# }
# # trading_parcel = TradingParcel.new(parcel_details)
# # trading_parcel.save(:validate => false)
# # trading_parcel1 = TradingParcel.new(rough_parcel1)
# # trading_parcel1.save(:validate => false)
# # trading_parcel2 = TradingParcel.new(rough_parcel2)
# # trading_parcel2.save(:validate => false)
# # trading_parcel3 = TradingParcel.new(polished_parcel)
# # trading_parcel3.save(:validate => false)
#
# demand1 = {description: 'Dummy Parcel for Demo', demand_supplier_id: dummy_co_1.id, block: 0,
#            deleted: 0, company_id: dummy_co_2
# }
# demand2 = {
#     description: 'Dummy Parcel for Demo',
#     demand_supplier_id: dummy_co_1.id, block: 0, deleted: 0,
#     company_id: dummy_co_2.id
# }
# demand3 = {
#     description: 'Dummy Parcel for Demo', demand_supplier_id: dummy_co_1.id, block: 0, deleted: 0,
#     company_id: dummy_co_2.id
# }
# Demand.find_or_create_by(demand1)
# Demand.find_or_create_by(demand2)
# Demand.find_or_create_by(demand3)
#
# transaction1 =
#     {
#         seller_id: dummy_co_2.id,
#         buyer_id: dummy_co_1.id,
#         trading_parcel_id: trading_parcel2.id,
#         due_date: Date.current + (trading_parcel2.credit_period).days,
#         price: 10,
#         transaction_type: 'manual',
#         credit: 30,
#         paid: 0,
#         buyer_confirmed: 1,
#         diamond_type: 'Rough',
#         description: trading_parcel2.description,
#         created_at: Time.now
#     }
# transaction2 = {
#     seller_id: dummy_co_2.id,
#     buyer_id: dummy_co_1.id,
#     trading_parcel_id: trading_parcel2.id,
#     due_date: Date.current - (trading_parcel2.credit_period).days,
#     price: 10,
#     transaction_type: 'manual',
#     credit: 30,
#     paid: 0,
#     buyer_confirmed: 1,
#     diamond_type: 'Rough',
#     created_at: Time.now
# }
# transaction3 = {
#     seller_id: dummy_co_2.id,
#     buyer_id: dummy_co_1.id,
#     trading_parcel_id: trading_parcel2.id,
#     due_date: Date.current + (trading_parcel2.credit_period).days,
#     price: 10,
#     transaction_type: 'manual',
#     credit: 30,
#     paid: 1,
#     buyer_confirmed: 1,
#     diamond_type: 'Rough',
#     created_at: Time.now
# }
# Transaction.find_or_create_by(transaction1)
# Transaction.find_or_create_by(transaction2)
# Transaction.find_or_create_by(transaction3)
# # CompaniesGroup.new
#
# company_group = {
#     group_name: 'Dummy Group',
#     seller_id: dummy_co_3.id,
#     company_id: [dummy_co_1.id, dummy_co_2.id],
#     group_market_limit: 200,
#     group_overdue_limit: 300
# }
# CompaniesGroup.find_or_create_by(company_group)
# CreditLimit.where(buyer_id: dummy_co_3.id, seller_id: dummy_co_2.id, credit_limit: 300).first_or_create
# DaysLimit.where(buyer_id: dummy_co_3.id, seller_id: dummy_co_2.id, days_limit: 25).first_or_create