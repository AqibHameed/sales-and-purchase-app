module Api
  module V1
    class StonesController <ApiController
      skip_before_action :verify_authenticity_token

      def upload
        if current_customer
          if params[:parcel_id].nil? || params[:parcel_id].blank? || params[:image].blank?
            render json: { errors: "Invalid Parameters", response_code: 201 }
          else
            stone = Stone.where(id: params[:parcel_id]).first
            if stone.nil?
              render json: { errors: "Parcel not found.", response_code: 201 }
            else
              parcel_image = ParcelImage.new(parcel_id: stone.id, image: params[:image])
              if parcel_image.save
                render json: { success: true, message: "Image successfully uploaded.", response_code: 200 }
              else
                render json: { success: false, message: "Some error in upload. Please try again", response_code: 201 }
              end
            end
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
        end
      end
    end
  end
end