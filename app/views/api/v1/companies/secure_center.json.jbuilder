json.success true
json.details do
  json.extract! @secure_center, :id, :invoices_overdue, :paid_date, :buyer_id, :seller_id, :outstandings, :overdue_amount, :last_bought_on, :buyer_percentage, :system_percentage
  json.supplier_connected @secure_center.supplier_paid
end
