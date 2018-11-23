module LimitsHelper

  def create_or_update_limits(transaction, parcel)

    credit_limit = CreditLimit.where(buyer_id: transaction.buyer_id, seller_id: current_company.id).first

    if credit_limit.nil?
      credit_limit = CreditLimit.create(buyer_id: transaction.buyer_id, seller_id: current_company.id, credit_limit: total_price, market_limit: total_price)
    else
      available_limit = get_available_credit_limit(transaction.buyer, current_company).to_f
      total_price = parcel.total_value
      if available_limit < total_price

        if available_limit > 0
            new_limit = credit_limit.credit_limit.to_f + (total_price.to_f - available_limit.to_f)
        else
            new_limit = credit_limit.credit_limit.to_f + total_price.to_f
        end
        if new_limit > credit_limit.market_limit.to_f
             new_market_limit =  new_limit
        end

        credit_limit.update_attributes(market_limit: new_market_limit, credit_limit: new_limit)
      end

    end

  end
end
