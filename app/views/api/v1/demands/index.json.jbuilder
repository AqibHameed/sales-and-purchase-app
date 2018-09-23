json.success true
json.response_code 200
json.demands(@all_demands) do |supplier|
  json.id supplier[:id]
  json.name supplier[:name]
  json.descriptions(supplier[:demands])
  # json.extract! demand, :id, :description, :company_id, :created_at, :updated_at, :demand_supplier_id
end