module Api
  module V1
    class CustomersController < ApiController
      skip_before_action :verify_authenticity_token, only: [:update_profile, :update_password, :approve_reject_customer_request]
      before_action :current_customer
      MOBILE_TILES_SHOW = {
          0 => 'Smart Search',
          1 => 'Available Parcel',
          2 => 'Inbox',
          3 => 'History',
          4 =>  'Live Monitor',
          5 => 'Public Channels',
          6 => 'Feedback',
          7 => 'Share App',
          8 => 'Invite',
          9 => 'Current Tenders',
          10 => 'Upcoming Tenders',
          11 => 'Protection',
          12 => 'Record Sale',
          13 => 'Past Tenders'
      }

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

      def update_password
        render json: { errors: "Not authenticated", response_code: 201 } and return unless current_customer
        render json: { success: false, message: "Invalid Current Password", response_code: 201 } and return unless current_customer.valid_password?(password_params[:current_password])
        render json: { success: false, message: "Provide New Password", response_code: 201 } and return unless password_params[:password].present?
        render json: { success: false, message: "Provide New Password Confirmation", response_code: 201 } and return unless password_params[:password_confirmation].present?
        render json: { success: false, message: "Doesn't Match Password", response_code: 201 } and return unless password_params[:password] == password_params[:password_confirmation]
        if current_customer.update(password_params.except(:current_password))
          render json: { success: true, message: 'Password Updated Successfully', response_code: 200 }
        else
          render json: { success: true, message: 'Invalid Parameters', response_code: 200 }
        end
      end

      def get_user_requests
        if current_company
          @requested_customers = []
          @customers = current_company.customers.where.not(id: current_customer.id)
          @customers.each do |c|
            @requested_customers << {
              id: c.id,
              first_name: c.first_name,
              last_name: c.last_name,
              email: c.email,
              is_requested: c.is_requested
            }
          end
          render json: { success: true, requested_customers: @requested_customers, response_code: 201 }
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def approve_reject_customer_request
        customer = Customer.where(id: params[:id]).first
        if customer.present?
          if params[:perform] == 'accept'
            if customer.update_attributes(is_requested: false)
              CustomerMailer.approve_access(customer).deliver
              render json: { success: true, message: 'Access Granted', response_code: 200 }
            else
              render json: { success: false, message: 'Some thing went wrong.', response_code: 201 }
            end
          elsif params[:perform] == 'reject'
            if customer.update_attributes(is_requested: true)
              CustomerMailer.remove_access(customer).deliver
              render json: { success: true, message: 'Access Denied successfully!!', response_code: 200 }
            else
              render json: { success: false, message: 'Some thing went wrong.', response_code: 201 }
            end
          else
            render json: { success: false, message: 'Invalid Action', response_code: 201 }
          end
        else
          render json: { success: false, message: 'Invalid Customer ID', response_code: 201 }
        end
      end

      def access_tiles
        if current_customer

            if current_customer.has_role?("Buyer")
              @messages = [{MOBILE_TILES_SHOW[0] => true}, {MOBILE_TILES_SHOW[2] => true}, {MOBILE_TILES_SHOW[3] => true}]
              render json: { success: true, messages: @messages }

            elsif current_customer.has_role?("Trader")
              @messages <<  {MOBILE_TILES_SHOW[0] => true}
              @messages << {MOBILE_TILES_SHOW[1] => true}
              @messages << {MOBILE_TILES_SHOW[2] => true}
              @messages << {MOBILE_TILES_SHOW[3] => true}
              @messages << {MOBILE_TILES_SHOW[4] => true}
              @messages << {MOBILE_TILES_SHOW[5] => true}
              @messages << {MOBILE_TILES_SHOW[6] => true}
              @messages << {MOBILE_TILES_SHOW[7] => true}
              @messages << {MOBILE_TILES_SHOW[8] => true}
              @messages << {MOBILE_TILES_SHOW[9] => true}
              @messages << {MOBILE_TILES_SHOW[10] => true}
              @messages << {MOBILE_TILES_SHOW[11] => true}
              @messages << {MOBILE_TILES_SHOW[12] => true}
              @messages << {MOBILE_TILES_SHOW[13] => true}

              render status: :ok, template: "api/v1/customers/permission.json.jbuilder"

            elsif current_customer.has_role?("Broker")
              @messages << {MOBILE_TILES_SHOW[5] => true}
              @messages << {MOBILE_TILES_SHOW[6] => true}
              @messages << {MOBILE_TILES_SHOW[7] => true}
              @messages << {MOBILE_TILES_SHOW[8] => true}
              @messages << {MOBILE_TILES_SHOW[9] => true}
              @messages << {MOBILE_TILES_SHOW[10] => true}
              @messages << {MOBILE_TILES_SHOW[13] => true}

              render status: :ok, template: "api/v1/customers/permission.json.jbuilder"
            end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:first_name, :last_name, :email, :mobile_no, :phone_2, :phone, :address, :city, :company, :company_address, :certificate)
      end

      def password_params
        params.require(:customer).permit(:current_password, :password, :password_confirmation)
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
