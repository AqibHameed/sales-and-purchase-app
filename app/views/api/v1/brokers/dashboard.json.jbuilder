json.success true
json.parcels @parcels.each do |parcel|
  json.description parcel.description
  json.no_of_parcels parcel.related_parcels(current_company).count
  json.no_of_demands parcel.demand_count(parcel, current_company, false)
end