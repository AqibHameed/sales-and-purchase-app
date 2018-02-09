module CustomersHelper

  def check_parcel_visibility(parcel, customer)
    if parcel.customer_id == customer.id
      true
    else
      if parcel.sale_none == true
        false
      elsif parcel.sale_all == true
        true
      elsif parcel.sale_broker == true
        parcel.broker_ids.include?(customer.id.to_s) rescue false
      elsif parcel.sale_demanded == true
        demands = Demand.where(description: parcel.description, customer_id: customer.id)
        if demands.exists?
          true
        else
          false
        end
      elsif parcel.sale_credit == true
        customer.has_limit(parcel.customer)
      else
        false
      end
    end
  end
end
