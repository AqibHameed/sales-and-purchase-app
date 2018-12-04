json.success true
json.details do
  json.extract! @secure_center, :id, :invoices_overdue, :paid_date, :buyer_id, :seller_id, :last_bought_on
  json.supplier_connected @secure_center.supplier_paid
  json.overdue_amount @secure_center.overdue_amount.to_f
  json.outstandings @secure_center.overdue_amount.to_f
  json.buyer_percentage @secure_center.buyer_percentage.to_i
  json.system_percentage @secure_center.system_percentage.to_i
end
