json.demands do
  json.dtc_demands @dtc_demands.each do |dtc_demand|
    json.extract! dtc_demand, :id, :description, :company_id, :created_at, :updated_at, :demand_supplier_id
  end

  json.russian_demands @russian_demands do |russian_demand|
    json.extract! russian_demand, :id, :description, :company_id, :created_at, :updated_at, :demand_supplier_id
  end

  json.outside_demands @outside_demands.each do |outside_demand|
    json.extract! outside_demand, :id, :description, :company_id, :created_at, :updated_at, :demand_supplier_id
  end

  json.something_special_demands @something_special_demands do |something_special_demand|
    json.extract! something_special_demand, :id, :description, :company_id, :created_at, :updated_at, :demand_supplier_id
  end
end