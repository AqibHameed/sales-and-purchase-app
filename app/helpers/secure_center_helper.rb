module SecureCenterHelper

   def secure_center_record(current_company,  buyer_id)

     @secure_center = SecureCenter.where("seller_id = ? AND buyer_id = ? ", current_company.id, buyer_id).last
     if @secure_center.present?
       render status: :ok, template: "api/v1/shared/limits_alert.json.jbuilder"
       #render json: { success: true, details: secure_center }
     else
       company = Company.where(id: buyer_id).first
       if company.present?
         secure_center = SecureCenter.new(seller_id: current_company.id, buyer_id: company.id)
         @secure_center = create_or_update_secure_center(secure_center, company, current_company)
         render status: :ok, template: "api/v1/shared/limits_alert.json.jbuilder"
       else
         render json: { errors: "Company with this id does not present.", response_code: 201 }
       end
     end
   end

end