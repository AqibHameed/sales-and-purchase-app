json.success false
json.details do
  json.extract! @secure_center, :id, :invoices_overdue, :paid_date, :buyer_id, :seller_id, :outstandings, :overdue_amount, :last_bought_on, :buyer_percentage, :system_percentage
  json.supplier_connected @secure_center.supplier_paid
  json.credit_limit @credit_limit
  json.overdue_limit @days_limit
end
