module SecureCenterHelper

   def secure_center_record(current_company,  buyer_id)

     @secure_center = SecureCenter.where("seller_id = ? AND buyer_id = ? ", current_company, buyer_id).last
     if @secure_center.present?
       render json: {status: :ok, template: "api/v1/shared/limits_alert"}
       #render json: { success: true, details: secure_center }
     else
       company = Company.where(id: buyer_id).first
       if company.present?
         @secure_center = save_secure_center(company)
         render json:{status: :ok, template: "api/v1/shared/limits_alert"}
       else
         render json: { errors: "Company with this id does not present.", response_code: 201 }
       end
     end
   end

   def save_secure_center(company)
     data = get_secure_center_record(company, current_company)
     data.merge!(buyer_id: company.id)
     data.merge!(seller_id: current_company.id)
     secure_center = SecureCenter.new(data)
     secure_center.save
     return secure_center
   end

end