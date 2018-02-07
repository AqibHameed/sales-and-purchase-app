module CustomersHelper

  def check_parcel_visibility(parcel, customer)
    visible = parcel.for_sale rescue ''
    puts visible
    if parcel.customer_id == customer.id
      true
    else
      if visible == 'to_all'
        true
      elsif visible == 'to_none'
        false
      elsif visible == 'broker'
        # parcel.broker_ids.include?(customer.id.to_s)
        false
      elsif visible == 'demanded'
        demands = Demand.where(description: parcel.description, customer_id: customer.id)
        if demands.exists?
          true
        else
          false
        end
      elsif visible == 'credit_given'
        customer.has_limit(parcel.customer)
      else
        false
      end
    end
  end
end
