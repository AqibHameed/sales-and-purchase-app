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
    "message": "Image successfully uploaded.",
    "images": [
        "https://s3.ap-south-1.amazonaws.com/idt-production/parcel_images/images/000/000/002/original/third_section_pic.png?1549279213",
        "https://s3.ap-south-1.amazonaws.com/idt-production/parcel_images/images/000/000/003/original/third_section_pic.png?1549279452",
        "https://s3.ap-south-1.amazonaws.com/idt-production/parcel_images/images/000/000/005/original/create_parcel.png?1549280387"
    ],
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
              #upload = Cloudinary::Uploader.upload(params[:image])
              parcel_image = ParcelImage.new(parcel_id: stone.id, customer_id: current_customer.id, image: params[:image])
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

# =begin
#  @apiVersion 1.0.0
#  @api {post} /api/v1/parcels/stone_update
#  @apiSampleRequest off
#  @apiName stone_update
#  @apiGroup Stones
#  @apiDescription update stones data
#  @apiParamExample {json} Request-Example:
# {
# "image": <image_object>
# "file" : <file_object>
# "stone_id" :4545
# "tender_id" :1215
# "description" : upadating_data
# "weight" : 24
# "color_mechine" : mechine
# "color_eye" : eye
# "fluorescence" : fluorescence
# "tention" : tention
# }
#  @apiSuccessExample {json} SuccessResponse:
#  {
#     {
#     "success": true,
#     "message": "data successfully updated",
#     "response_code": 200
# }
#  }
# =end


      def stone_update
        if current_customer
          stone_data = StoneDetail.find_by(stone_id: params[:stone_id], tender_id: params[:tender_id], customer_id: current_customer.id)
          if stone_data.present?

            if stone_data.update_attributes(stone_details_params)
              render json: {success: true, message: "data successfully updated", response_code: 200}
            else
              render json: {error: false, message: "data doesn't updated", response_code: 200}
            end
          else
            render json: {message: "Stone_data doesn't exists against this stone"}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/bid_history?parcel_id=1
 @apiSampleRequest off
 @apiName last 3 bids
 @apiGroup Stones
 @apiDescription get bids history on parcel with respect to parcel id
 @apiSuccessExample {json} SuccessResponse:
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

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/parcels/wish_list_record?stone_id=3
 @apiSampleRequest off
 @apiName wish_list_record
 @apiGroup Stones
 @apiDescription  create/update wish_list record of stone
 @apiParamExample {json} Request-Example1:
{

"stone_id" :3
"wish_status" :true


}
 @apiSuccessExample {json} SuccessResponse1:

   {
    "success": true,
    "message": "data successfully created",
    "response_code": 200
   }
 @apiParamExample {json} Request-Example2:
{

"stone_id" :3
"wish_status" :true


}
 @apiSuccessExample {json} SuccessResponse2:

   {
    "success": true,
    "message": "data successfully updated",
    "response_code": 200
   }


=end

      def wish_list_record
        if current_customer
          stone_wishlist = Stone.find_by(id: params[:stone_id])
          if stone_wishlist.nil?
            render json: {errors: 'Parcel not found', response_code: 201}
          else
            wish_list_status = WishList.find_by(stone_id: stone_wishlist.id)
            if wish_list_status.nil?
              wish_list_status = WishList.new(wish_list_params)
              wish_list_status.save
              render json: {success: true, message: "data successfully created", response_code: 200}
            else
              wish_list_status.update_attributes(wish_list_params)
              render json: {success: true, message: "data successfully updated", response_code: 200}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
        end
      end





      private

      def stone_details_params
        params.permit(:stone_id, :tender_id, :description, :weight, :color_mechine, :color_eye, :fluorescence, :tention, :image, :file).merge(customer_id: current_user.id)
      end

      def wish_list_params
        params.permit(:stone_id, :wish_status)
      end


    end
  end
end


