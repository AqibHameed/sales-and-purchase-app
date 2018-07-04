module CustomersHelper

  def check_parcel_visibility(parcel, company)
    if parcel.company_id == company.id
      true
    else
      if current_company.is_blocked_by_supplier(parcel.try(:company_id))
        false
      elsif parcel.sale_none == true
        false
      elsif parcel.sale_all == true
        true
      elsif parcel.sale_broker == true
        parcel.broker_ids.include?(company.id.to_s) rescue false
      elsif parcel.sale_demanded == true
        demands = Demand.where(description: parcel.description, company_id: company.id)
        if demands.exists?
          true
        else
          false
        end
      elsif parcel.sale_credit == true
        company.has_limit(parcel.try(:company).try(:id))
      else
        false
      end
    end
  end

  def parcel_demanded(parcel, company)
    if Demand.where(description: parcel.description, company_id: company.id).exists?
      true
    else
      false
    end
  end

  def last_3_trading_avg(histories)
    count = histories.count
    total = histories.map { |e| e.total_amount  }.sum
    avg = total/count rescue 0
    number_with_precision(avg, precision: 2)
  end
end
