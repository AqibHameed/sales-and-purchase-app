json.success false
json.details do
  json.extract! @secure_center, :id, :invoices_overdue, :paid_date, :buyer_id, :seller_id, :last_bought_on
  json.supplier_connected @secure_center.supplier_paid
  json.credit_limit @credit_limit
  json.overdue_limit @days_limit
  json.overdue_amount @secure_center.overdue_amount.to_f
  json.outstandings @secure_center.outstandings.to_f
  json.buyer_percentage @secure_center.buyer_percentage
  json.system_percentage @secure_center.system_percentage
end
