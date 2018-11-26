module LimitsHelper

  def create_or_update_limits(transaction, parcel)
    #companies_group = CompaniesGroup.find_by(company_id: [transaction.buyer_id], seller_id: current_company.id)
    total_price = parcel.total_value

    # if companies_group.present?
    #
    #   available_market_limit = get_available_market_limit_companies_group(companies_group.company_id, companies_group).to_f
    #
    #   if available_market_limit < total_price
    #
    #     if available_market_limit > 0
    #       new_market_limit = companies_group.group_market_limit.to_f + (total_price.to_f - available_market_limit.to_f)
    #     else
    #       new_market_limit = companies_group.group_market_limit.to_f + total_price.to_f
    #     end
    #     companies_group.update_attributes(market_limit: new_market_limit)
    #   end
    #
    # else

      credit_limit = CreditLimit.where(buyer_id: transaction.buyer_id, seller_id: current_company.id).first

      if credit_limit.nil?
        credit_limit = CreditLimit.create(buyer_id: transaction.buyer_id, seller_id: current_company.id, credit_limit: total_price, market_limit: total_price)
      else
        available_credit_limit = get_available_credit_limit(transaction.buyer, current_company).to_f
        available_market_limit = get_available_market_limit(transaction.buyer, credit_limit).to_f

        if available_credit_limit < total_price

          if available_credit_limit > 0
            new_limit = credit_limit.credit_limit.to_f + (total_price.to_f - available_credit_limit.to_f)
          else
            new_limit = credit_limit.credit_limit.to_f + total_price.to_f
          end
          credit_limit.update_attributes(credit_limit: new_limit)
        end

        if available_market_limit < total_price

          if available_market_limit > 0
            new_market_limit = credit_limit.market_limit.to_f + (total_price.to_f - available_market_limit.to_f)
          else
            new_market_limit = credit_limit.market_limit.to_f + total_price.to_f
          end
          credit_limit.update_attributes(market_limit: new_market_limit)

        end

      end

    #end

  end
end
