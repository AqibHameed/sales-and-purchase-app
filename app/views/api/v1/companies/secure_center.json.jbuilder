json.success true
json.details do
  json.extract! @secure_center, :id, :invoices_overdue, :paid_date, :supplier_paid, :supplier_unpaid, :buyer_id, :seller_id, :outstandings, :overdue_amount, :last_bought_on, :percentage, :activity_bought
end