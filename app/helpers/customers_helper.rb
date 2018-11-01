module CustomersHelper

  def check_parcel_visibility(parcel, company)
    demanded = Demand.where(company_id: current_company.id, description: parcel.description, deleted: false).first
    if parcel.company_id == company.id && demanded.present?
      true
    else
      if current_company.is_blocked_by_supplier(parcel.try(:company_id))
        false
      # elsif parcel.sale_none == true
      #   false
      # elsif parcel.sale_all == true
      #   true
      elsif parcel.sale_demanded == true
        demands = Demand.where(description: parcel.description, company_id: company.id)
        polished_demand = PolishedDemand.where(description: parcel.description, company_id: company.id)
        if demands.exists? || polished_demand.exists?
          true
        else
          false
        end
      elsif parcel.sale_broker == true
        parcel.broker_ids.include?(company.id.to_s) rescue false
      # elsif parcel.sale_credit == true
      #   company.has_limit(parcel.try(:company).try(:id))
      else
        false
      end
    end
  end

  def check_parcel_visibility_for_my_parcels(parcel, company)
    if parcel.company_id == company.id
      true
    else
      false
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
    total = histories.map { |e| e.price  }.sum
    avg = total/count rescue 0
    number_with_precision(avg, precision: 2)
  end

  def get_last_demand_date(parcels)
    ids = []
    parcels.each do |p|
     ids << p.id
    end
    last = Demand.order("created_at DESC").where(:id => ids).first
    return last.created_at
  end

  def check_for_negotiation(proposal, current_company)
    if proposal.negotiations.present? && proposal.negotiations.last.whose == current_company
      true
    else
      false
    end
  end
end
