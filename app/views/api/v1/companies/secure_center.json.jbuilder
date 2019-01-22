json.success true
json.details do
  if @request.present? && @request.status == 'accepted' && @request.secure_center || params[:receiver_id] == current_company.id.to_s
    json.extract! @secure_center, :id, :invoices_overdue, :buyer_id, :seller_id, :last_bought_on
    json.supplier_connected @secure_center.supplier_paid
    json.overdue_amount @secure_center.overdue_amount.to_f
    json.outstandings @secure_center.outstandings.to_f
    json.buyer_percentage @secure_center.buyer_percentage.to_f
    json.system_percentage @secure_center.system_percentage.to_f
    json.balance_credit_limit @credit_limit.credit_limit
    json.permitted true
    # json.payment_score @secure_center.payment_score
    json.number_of_seller_offer_credit @number_of_seller_offer_credit_limit
    # json.market_payment_score @secure_center.market_payment_score
    json.collection_ratio_days @secure_center.collection_ratio_days
    json.buyer_score @buyer_score.total
    json.seller_score @seller_score.total
  else
    json.outstandings @secure_center.outstandings.to_f
    json.overdue_amount @secure_center.overdue_amount.to_f
    json.supplier_connected @secure_center.supplier_paid
    json.permitted false
    json.balance_credit_limit @credit_limit.credit_limit
    # json.payment_score @secure_center.payment_score
    json.collection_ratio_days @secure_center.collection_ratio_days
    # json.market_payment_score @secure_center.market_payment_score
  end
  if @secure_center.paid_date.present?
    json.paid_date @secure_center.paid_date
  else
    json.paid_date 'N/A'
  end
end
