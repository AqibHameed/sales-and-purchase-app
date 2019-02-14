module Api
  module V1
    class Api::V1::StoneDetailsController < ApiController
      skip_before_action :verify_authenticity_token

=begin
  @apiVersion 1.0.0
  @api {get} /api/v1/stone_details
  @apiSampleRequest off
  @apiName index
  @apiGroup StoneDetails
  @apiDescription show stone details
  @apiParamExample {json} Request-Example:
  {

      "stone_id" :3

  }
  @apiSuccessExample {json} SuccessResponse:
  {
    {
       "success": true,
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
            }
          ]
    }
 }
=end

      def index
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
  @api {post} /api/v1/stone_details
  @apiSampleRequest off
  @apiName create
  @apiGroup StoneDetails
  @apiDescription create stone details
  @apiParamExample {json} Request-Example:
      {
         "image": <image_object>
         "file" : <file_object>
         "stone_id" :4546
        "tender_id" :1216
        "description" : description
        "weight" : 22
        "color_mechine" : color_mechine
        "color_eye" : color_eye
        "fluorescence" : fluorescence
        "tention" : tention
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

      def create
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

      private
      def stone_details_params
        params.permit(:stone_id, :tender_id, :description, :weight, :color_mechine, :color_eye, :fluorescence, :tention, :image, :file).merge(customer_id: current_user.id)
      end
    end
  end
end
