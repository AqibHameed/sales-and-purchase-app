class Api::V1::RegistrationsController < ActionController::Base

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/signup
 @apiSampleRequest off
 @apiName signup
 @apiGroup Registeration
 @apiDescription Sign up Customer
 @apiParamExample {json} Request-Example1:
{
	{
   "registration": {
      "first_name":"umair",
      "last_name":"raza",
      "email":"umair@gmail.com",
      "password":"password",
      "confirmPassword":"password",
      "company_id":"4",
      "mobile_no":"12345688898",
      "country_code":"86",
      "role": "Buyer/Trader/Broker",
      "company_individual": "Individual"
    }
  }
}
 @apiSuccessExample {json} SuccessResponse1:
{
    {
      "success": true,
      "message": "A request has been to sent to your company admin for approval. You can access your account after approval",
      "customer": {
          "id": 23,
          "email": "umair@gmail.com",
          "created_at": "2018-12-24T13:15:52.000Z",
          "updated_at": "2018-12-24T13:15:57.000Z",
          "first_name": "umair",
          "last_name": "raza",
          "city": null,
          "address": null,
          "postal_code": null,
          "phone": null,
          "status": null,
          "company": "Seller A",
          "company_address": null,
          "phone_2": null,
          "mobile_no": "+86 12345688898",
          "authentication_token": "_iw1Ns3W3Su3QpMrT88e",
          "chat_id": "-1",
          "token": null
     },
     "response_code": 200
   }
}

@apiParamExample {json} Request-Example1:
{
	{
   "registration": {
      "first_name":"umair",
      "last_name":"raza",
      "email":"umair@gmail.com",
      "password":"password",
      "confirmPassword":"password",
      "company_id":"4",
      "mobile_no":"12345688898",
      "country_code":"86",
      "role": "Trader/Broker",
      "company_individual": "Individual"
    }
  }
}

@apiSuccessExample {json} SuccessResponse1:
{
  {
      "errors": [
          "Company already registered as Trader"
      ],
      "response_code": 201
  }
}
=end


  def create
    # check_company = Company.where(name: params[:registration][:company_id]).first
    # if check_company.customer
    #   is_requested = false
    # else
    #   check_company = check_company
    #   is_requested = true
    # end
    if params[:registration][:company_id].present?
      @company = Company.find(params[:registration][:company_id])
    else
      if params[:registration][:company_individual].present?
        if params[:registration][:company_individual] == "Individual" && params[:registration][:role] == Role::BROKER
          string = "#{params[:registration][:first_name]}"+"#{params[:registration][:last_name]}"+"("+"#{params[:registration][:role]}"+")"
          @company = Company.where(name: string).first_or_create
          params[:registration].delete("company_id")
          params[:registration].merge!("company_id"  =>  @company.id)
        end
      end
    end
    customer = Customer.new(customer_params)

    unless params[:registration][:role].blank? || params[:registration][:company_id].blank?
      if params[:registration][:role] == Role::BROKER
        @company.try(:customers).present? ? customer.errors.add(:company, 'already registered as Trader') : ''
      else
        @company.is_broker ? customer.errors.add(:company, 'already registered as broker') : ''
      end
    end


    unless customer.errors.present?
      if customer.save
        customer.ensure_authentication_token
        mobile_no = '+'+params[:registration][:country_code]+' '+params[:registration][:mobile_no]
        customer.mobile_no = mobile_no
        customer.save!
        response.headers['Authorization'] = customer.authentication_token
        token = customer.generate_jwt_token
        if customer.confirmed?
          if customer.is_requested
            render :json => { success: true, message: 'A request has been to sent to your company admin for approval. You can access your account after approval', customer: customer_data(customer, token), response_code: 200 }
          else
            render :json => { success: true, customer: customer_data(customer, token), response_code: 200 }
          end
        else
          render :json => { success: true, message: 'An email has been sent to your email. Please verify the email.', customer: customer_data(customer, token), response_code: 200 }
        end
      else
          render :json => {:errors => customer.errors.full_messages, response_code: 201 }
      end
    else
      # check_company.destroy unless check_company.try(:customers).present?
      render :json => {:errors => customer.errors.full_messages, response_code: 201 }
    end
  end

  private
  def customer_data(customer, token)
    {
      id: customer.id,
      email:  customer.email,
      created_at: customer.created_at,
      updated_at: customer.updated_at,
      first_name: customer.first_name,
      last_name: customer.last_name,
      city: customer.city,
      address: customer.address,
      postal_code: customer.postal_code,
      phone: customer.phone,
      status: customer.status,
      company: customer.company.try(:name),
      company_address: customer.company_address,
      phone_2: customer.phone_2,
      mobile_no: customer.mobile_no,
      authentication_token: customer.authentication_token,
      chat_id: customer.chat_id,
      token: token
    }
  end

  def customer_params
    params.require(:registration).permit(:email, :password, :first_name, :last_name, :city, :address, :postal_code, :phone, :status, :company_address, :phone_2, :mobile_no, :company_id, :company_name, :confirmed_at, :is_requested, :role)
  end
end