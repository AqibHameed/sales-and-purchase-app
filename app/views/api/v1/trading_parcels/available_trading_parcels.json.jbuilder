json.success true
json.response_code 200
json.parcels(@all_parcels) do |supplier|
  json.id supplier[:id]
  json.name supplier[:name]
  json.descriptions supplier[:parcels]
end