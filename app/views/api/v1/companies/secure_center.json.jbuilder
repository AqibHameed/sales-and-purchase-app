json.success true
json.details do
  json.extract! @secure_center, :id, :buyer_id, :seller_id
  if @request.present? && @request.status == 'accepted' && @request.secure_center || params[:receiver_id] == current_company.id.to_s
    json.supplier_connected @secure_center.supplier_paid
    json.overdue_amount @secure_center.overdue_amount.to_f
    json.invoices_overdue @secure_center.invoices_overdue
    json.outstandings @secure_center.outstandings.to_f
    json.last_bought_on  @secure_center.last_bought_on.present? ?  @secure_center.last_bought_on.iso8601 : @secure_center.last_bought_on
    json.buyer_percentage @secure_center.buyer_percentage.to_f
    json.system_percentage @secure_center.system_percentage.to_f
    json.balance_credit_limit @credit_limit.credit_limit
    json.permitted true
    # json.payment_score @secure_center.payment_score
    json.number_of_seller_offer_credit @number_of_seller_offer_credit_limit
    # json.market_payment_score @secure_center.market_payment_score
    json.collection_ratio_days @secure_center.collection_ratio_days
    json.buyer_score @buyer_score.total
    # json.seller_score @seller_score.total
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
  json.paid_date @secure_center.paid_date.present? ? @secure_center.paid_date.iso8601 : @secure_center.paid_date
end
