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

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/parcels/stone_details
 @apiSampleRequest off
 @apiName stone_details
 @apiGroup Stones
 @apiDescription saving stone_details
 @apiParamExample {json} Request-Example:
{
"image": <image_object>
"file" : <file_object>
"stone_id" :4546
"tender_id" :1216
"description" : stone_image
"weight" : 22
"color_mechine" : image
"color_eye" : image
"fluorescence" : image
"tention" : image
}
 @apiSuccessExample {json} SuccessResponse:
 {
    {
    "success": true,
    "message": "data successfully uploaded",
    "response_code": 200
}
 }
=end

      def stone_details
        if current_customer
          stone_data = StoneDetail.where(stone_id: params[:stone_id], tender_id: params[:tender_id], customer_id: current_customer.id)
          if stone_data.present?
            render json: {message: "Stone_data exists against this stone"}
          else
            stone_details = StoneDetail.new(stone_details_params)
            if stone_details.save
              render json: {success: true, message: "data successfully uploaded", response_code: 200}
            else
              render json: {success: false, errors: stone_details.errors.full_messages, response_code: 201}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
        end
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/parcels/stone_update
 @apiSampleRequest off
 @apiName stone_update
 @apiGroup Stones
 @apiDescription update stones data
 @apiParamExample {json} Request-Example:
{
"image": <image_object>
"file" : <file_object>
"stone_id" :4545
"tender_id" :1215
"description" : upadating_data
"weight" : 24
"color_mechine" : image_mechine
"color_eye" : image_eye
"fluorescence" : image_fluorescence
"tention" : image_tention
}
 @apiSuccessExample {json} SuccessResponse:
 {
    {
    "success": true,
    "message": "data successfully updated",
    "response_code": 200
}
 }
=end


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
 @api {post} /api/v1/parcels/stone_stone
 @apiSampleRequest off
 @apiName stone_show
 @apiGroup Stones
 @apiDescription show customer data of stone_id
 @apiParamExample {json} Request-Example:
{

"stone_id" :3

}
 @apiSuccessExample {json} SuccessResponse:
 {
    {
    " "success": true,
    "stone_details": [
        {
             "id": 1,
            "stone_id": 3,
            "tender_id": 392,
            "customer_id": 21,
            "description": "usman",
            "weight": null,
            "color_mechine": null,
            "color_eye": null,
            "fluorescence": null,
            "tention": null,
            "created_at": "2019-02-07T14:28:21.000Z",
            "updated_at": "2019-02-07T14:28:21.000Z",
            "image_file_name": "1",
            "image_content_type": "image/png",
            "image_file_size": 98341,
            "image_updated_at": "2019-02-07T14:28:20.000Z",
            "file_file_name": "testccases",
            "file_content_type": "text/x-ruby",
            "file_file_size": 8589,
            "file_updated_at": "2019-02-07T14:28:21.000Z"
        }]
}
 }
=end

      def stone_show
        if params[:stone_id].blank?
          render json: {error: "invalid parameter ,Enter stone_id"}
        else
          stone_details = StoneDetail.where(stone_id: params[:stone_id])
          # stone_customer_details = stone_details.includes(:customer).map(&:customer).uniq
          render json: {success: true,
                        stone_details: stone_details,
                        response_code: 200}
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
      private
      def stone_details_params
        params.permit(:stone_id, :tender_id, :description, :weight, :color_mechine, :color_eye, :fluorescence, :tention, :image, :file).merge(customer_id: current_user.id)
      end
    end
  end
end