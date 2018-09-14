module Api
  module V1
    class CustomersController < ApiController
      skip_before_action :verify_authenticity_token, only: [:update_profile]
      before_action :current_customer

      def profile
        if current_customer
          render json: { profile: profile_data(current_customer), response_code: 200 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def update_profile
        if current_customer
          if current_customer.update_attributes(customer_params)
            render json: { success: true, message: 'Profile Updated Successfully', response_code: 200 }
          else
            render json: { success: false, message: 'Invalid Parameters', response_code: 201 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:first_name, :last_name, :email, :mobile_no, :phone_2, :phone, :address, :city, :company, :company_address, :certificate)
      end

      def profile_data(customer)
        {
          id: customer.id,
          first_name: customer.first_name,
          last_name: customer.last_name,
          email: customer.email,
          phone: customer.phone,
          city: customer.city,
          address: customer.address,
          phone_2: customer.phone_2,
          mobile_no: customer.mobile_no,
          company: customer.company.name,
          company_address: customer.company_address,
          created_at: customer.created_at,
          updated_at: customer.updated_at
        }
      end
    end
  end
end
