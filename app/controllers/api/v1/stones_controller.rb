module Api
  module V1
    class StonesController <ApiController
      skip_before_action :verify_authenticity_token

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/parcels/upload
 @apiSampleRequest off
 @apiName upload
 @apiGroup Stones
 @apiDescription Upload image for stone parcels
 @apiParamExample {json} Request-Example:
{
"parcel_id": 167 ,
"image": <image_object>
}
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": 'Image successfully uploaded.',
    "response_code": 200
}
=end

      def upload
        if current_customer
          if params[:parcel_id].nil? || params[:parcel_id].blank? || params[:image].blank?
            render json: { errors: "Invalid Parameters", response_code: 201 }
          else
            stone = Stone.where(id: params[:parcel_id]).first
            if stone.nil?
              render json: { errors: "Parcel not found.", response_code: 201 }
            else
              upload = Cloudinary::Uploader.upload(params[:image])
              parcel_image = ParcelImage.new(parcel_id: stone.id, customer_id: current_customer.id, image_url: upload["secure_url"])
              if parcel_image.save
                images = stone.parcel_images.where(customer_id: current_customer.id).map { |e| e.try(:image_url)}.compact
                render json: { success: true, message: "Image successfully uploaded.", images: images, response_code: 200 }
              else
                render json: { success: false, message: "Some error in upload. Please try again", response_code: 201 }
              end
            end
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/bid_history?parcel_id=1
 @apiSampleRequest off
 @apiName last 3 bids
 @apiGroup Stones
 @apiDescription get bids history on parcel with respect to parcel id
 @apiSuccessExample {json} SuccessResponse1:
{
    "errors": "Parcel not found",
    "response_code": 201
}
=end

      def last_3_bids
        if current_customer
          stone = Stone.where(id: params[:parcel_id]).first
          if stone.nil?
            render json: { errors: "Parcel not found", response_code: 201 }
          else
            bid_history = Bid.last_3_bids(current_customer.id, stone.description, stone.tender.try(:supplier_id))
            render json: { bids: bid_history, response_code: 200 }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }, status: :unauthorized
        end
      end
    end
  end
end