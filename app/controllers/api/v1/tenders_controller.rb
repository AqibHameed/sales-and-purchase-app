module Api
  module V1
    class TendersController <ApiController
      before_action :current_customer
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token, only: [:index]
=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/tenders
 @apiSampleRequest off
 @apiName tenders
 @apiGroup Tenders
 @apiDescription list of all tenders
 @apiSuccessExample {json} SuccessResponse1:
 {
    "success": true,
    "pagination": {
        "total_pages": 8,
        "prev_page": null,
        "next_page": "http://localhost:3000/api/v1/tenders?page=2",
        "current_page": 1
    },
    "tenders": [
        {
            "id": 1003,
            "name": "Cullinan Jan-Feb 2018",
            "start_date": "2013-10-19T00:00:00.000Z",
            "end_date": "2018-02-07T03:30:00.000Z",
            "company_name": "Petra Diamonds",
            "company_logo": null,
            "city": "Johannesburg",
            "country": "",
            "notification": false
        },
        {
            "id": 383,
            "name": "Transhex 229A January 2016",
            "start_date": "2016-01-25T05:05:00.000Z",
            "end_date": "2016-02-08T07:05:00.000Z",
            "company_name": "Trans-hex",
            "company_logo": null,
            "city": "Johannesburg",
            "country": "South Africa",
            "notification": false
        }
    ],
    "response_code": 200
  }
=end
=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/tenders?month=1
 @apiSampleRequest off
 @apiName tenders month
 @apiGroup Tenders
 @apiDescription tenders according to month
 @apiSuccessExample {json} SuccessResponse2:
 {
    "success": true,
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "tenders": [
        {
            "id": 383,
            "name": "Transhex 229A January 2016",
            "start_date": "2016-01-25T05:05:00.000Z",
            "end_date": "2016-02-08T07:05:00.000Z",
            "company_name": "Trans-hex",
            "company_logo": null,
            "city": "Johannesburg",
            "country": "South Africa",
            "notification": false
        }
    ],
    "response_code": 200
  }
=end
=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/tenders?location=surat
 @apiSampleRequest off
 @apiName tenders location
 @apiGroup Tenders
 @apiDescription tenders according to Location
 @apiSuccessExample {json} SuccessResponse3:
 {
    "success": true,
    "pagination": {
        "total_pages": 2,
        "prev_page": null,
        "next_page": "http://localhost:3000/api/v1/tenders?page=2&month=1",
        "current_page": 1
    },

    "tenders": [
        {
            "id": 383,
            "name": "Transhex 229A January 2016",
            "start_date": "2016-01-25T05:05:00.000Z",
            "end_date": "2016-02-08T07:05:00.000Z",
            "company_name": "Trans-hex",
            "company_logo": null,
            "city": "Johannesburg",
            "country": "South Africa",
            "notification": false
        },
    ],
    "response_code": 200
  }
=end
=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/tenders?supplier=11
 @apiSampleRequest off
 @apiName tenders
 @apiGroup Tenders
 @apiDescription tenders according to supplier
 @apiSuccessExample {json} SuccessResponse4:
 {
    "success": true,
    "pagination": null,
    "tenders": [],
    "response_code": 200
 }
=end


      def index
        col_str = ""
        if params[:location] || params[:month] || params[:supplier]
          col_str = "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        tenders = Tender.includes(:supplier).tenders_state(params[:state]).where(col_str).order("open_date")
        # @tenders = tender.page(params[:page]).pcoer(params[:count])

        @tenders = tenders.page(params[:page]).per(params[:count])
        render json: {success: true, pagination: set_pagination(:tenders), tenders: tender_data(@tenders), response_code: 200}
      end


      def upcoming
        col_str = "open_date > '#{Time.zone.now}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str += " AND (tenders.country LIKE '%#{params[:location]}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tender = Tender.where(col_str).order("open_date")
        else
          tender = Tender.where(col_str).order("open_date")
        end
        @tenders = tender.page(params[:page]).per(params[:count])
        render json: {success: true, pagination: set_pagination(:tenders), tenders: tender_data(@tenders), response_code: 200}
        # col_str = ""
        # upcoming_str = "open_date > '#{Time.zone.now}'"
        # if params[:location] || params[:month] || params[:supplier]
        #   col_str =  "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')"  unless params[:location].blank?
        #   col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
        #   col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        # end
        # if current_customer
        #   active_tenders = current_customer.tenders.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = current_customer.tenders.where(upcoming_str).where(col_str).order("created_at desc")
        # else
        #   active_tenders = Tender.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = Tender.where(upcoming_str).where(col_str).order("created_at desc")
        # end
        # tenders = active_tenders + upcoming_tenders
        # render json: { tenders: tender_data(tenders), response_code: 200 }
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/tenders/closed
 @apiSampleRequest off
 @apiName closed
 @apiGroup Tenders
 @apiDescription List of closed tenders
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "tenders": [],
    "response_code": 200
}
=end


      def closed
        col_str = "close_date < '#{Time.zone.now}' AND close_date > '#{4.month.ago}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str += " AND (tenders.country LIKE '%#{params[:location]}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tenders = Tender.where(col_str).order("created_at desc")
        else
          tenders = Tender.where(col_str).order("created_at desc")
        end
        render json: {success: true, tenders: closed_tender_data(tenders), response_code: 200}
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/old_tenders
 @apiSampleRequest off
 @apiName old tender
 @apiGroup Tenders
 @apiDescription get old tenders
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "tenders": [
        {
            "id": 982,
            "name": "DEMO ",
            "start_date": "2018-01-05T13:00:00.000Z",
            "end_date": "2018-12-31T12:56:00.000Z",
            "company_name": "DEMO",
            "company_logo": null,
            "city": "Surat",
            "country": "India",
            "notification": false
        }
    ],
    "response_code": 200
}
=end


      def old_tenders
        col_str = ""
        if params[:location] || params[:month] || params[:supplier]
          col_str = "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tender = Tender.active.where(col_str).order("open_date")
        else
          tender = Tender.active.where(col_str).order("open_date")
        end
        @tenders = tender.page(params[:page]).per(params[:count])
        render json: {success: true, pagination: set_pagination(:tenders), tenders: old_tender_data(@tenders), response_code: 200}
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/old_upcoming
 @apiSampleRequest off
 @apiName old upcoming
 @apiGroup Tenders
 @apiDescription old up coming
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "tenders": [
        {
            "id": 1123,
            "name": "ODC January 2019",
            "start_date": "2019-01-20T01:30:00.000Z",
            "end_date": "2019-01-30T05:46:00.000Z",
            "company_name": "Okavango Diamond Company",
            "company_logo": null,
            "city": "Gaborone",
            "country": "BW",
            "notification": false
        }
    ],
    "response_code": 200
}
=end

      def old_upcoming
        col_str = "open_date > '#{Time.zone.now}'"
        if params[:location] || params[:month] || params[:supplier]
          col_str += " AND (tenders.country LIKE '%#{params[:location]}%')" unless params[:location].blank?
          col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
          col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:supplier]}" : " AND tenders.supplier_id = #{params[:supplier]}" unless params[:supplier].blank?
        end
        if current_customer
          tenders = Tender.where(col_str).order("open_date")
        else
          tenders = Tender.where(col_str).order("open_date")
        end
        render json: {success: true, tenders: old_tender_data(tenders), response_code: 200}
        # col_str = ""
        # upcoming_str = "open_date > '#{Time.zone.now}'"
        # if params[:location] || params[:month] || params[:supplier]
        #   col_str =  "(lower(tenders.country) LIKE '%#{params[:location].downcase}%')"  unless params[:location].blank?
        #   col_str += (col_str.blank?) ? "extract(month from open_date) = #{params[:month]}" : " AND extract(month from open_date) = #{params[:month]}" unless params[:month].blank?
        #   col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:supplier]}" : " AND tenders.company_id = #{params[:supplier]}" unless params[:supplier].blank?
        # end
        # if current_customer
        #   active_tenders = current_customer.tenders.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = current_customer.tenders.where(upcoming_str).where(col_str).order("created_at desc")
        # else
        #   active_tenders = Tender.active.where(col_str).order("created_at desc")
        #   upcoming_tenders = Tender.where(upcoming_str).where(col_str).order("created_at desc")
        # end
        # tenders = active_tenders + upcoming_tenders
        # render json: { tenders: tender_data(tenders), response_code: 200 }
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/old_tender_parcel?tender_id=3
 @apiSampleRequest off
 @apiName old tender parcel
 @apiGroup Tenders
 @apiDescription old tender parcels
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "tender_parcels": [],
    "response_code": 200
}
=end

      def old_tender_parcel
        stones = Stone.where(tender_id: params[:tender_id])
        render json: {success: true, tender_parcels: winners_stone_data(stones), response_code: 200}
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/tender_parcel?tender_id=1
 @apiSampleRequest off
 @apiName tender parcel
 @apiGroup Tenders
 @apiDescription tender parcels detail
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "pagination": {
        "total_pages": 2,
        "prev_page": null,
        "next_page": "http://localhost:3000/api/v1/tender_parcel?page=2&tender_id=1115",
        "current_page": 1
    },
    "tender_parcels": [
        {
            "id": 1270,
            "stone_type": "Parcel",
            "no_of_stones": 14,
            "size": null,
            "weight": 206.61,
            "purity": null,
            "color": null,
            "polished": null,
            "deec_no": 1,
            "lot_no": 1,
            "description": "+10.8CT CLIVAGE",
            "comments": null,
            "valuation": null,
            "wish_list_status": true,
            "parcel_rating": null,
            "images": [],
            "winners_data": [],
            "highlight_parcel": false
        },
        {
            "id": 1271,
            "stone_type": "Parcel",
            "no_of_stones": 2,
            "size": null,
            "weight": 24.6,
            "purity": null,
            "color": null,
            "polished": null,
            "deec_no": 2,
            "lot_no": 2,
            "description": "+10.8CT BROWN MIX",
            "comments": null,
            "valuation": null,
            "wish_list_status": false,
            "parcel_rating": null,
            "images": [],
            "winners_data": [],
            "highlight_parcel": false
        }
    ],
    "response_code": 200
  }
=end

      def tender_parcel
        stones = Stone.includes(:stone_ratings).where(tender_id: params[:tender_id])
        @stones = stones.page(params[:page]).per(params[:count])
        render json: {success: true, pagination: set_pagination(:stones), tender_parcels: stone_data(@stones), response_code: 200}
      end



=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/stone_parcel
 @apiSampleRequest off
 @apiName stone parcel
 @apiGroup Tenders
 @apiDescription Tender's Stone parcel
 @apiParamExample {json} Request-Example:
{
	"comments": "this is comment",
	"valuation": "",
	"parcel_rating": "",
	"id": 4546
}
 @apiSuccessExample {json} SuccessResponse:
{
    "stone_parcel": {
        "id": 4546,
        "comments": "this is comment",
        "valuation": "",
        "parcel_rating": null,
        "lot_no": 6,
        "tender_id": 1216,
        "description": "-9+1 R.O.M",
        "no_of_stones": 1,
        "weight": 327.46,
        "carat": null,
        "stone_type": "Parcel",
        "size": null,
        "purity": null,
        "color": null,
        "polished": null,
        "created_at": "2019-01-24T10:09:25.000Z",
        "updated_at": "2019-01-24T10:09:25.000Z",
        "deec_no": 6,
        "system_price": null,
        "lot_permission": null,
        "reserved_price": null,
        "yes_no_system_price": null,
        "stone_winning_price": null
    },
    "response_code": 200
}

@apiParamExample {json} Request-Example:
{
	"comments": "",
	"valuation": "",
	"parcel_rating": "",
	"id": 4545
}
 @apiSuccessExample {json} SuccessResponse:
{
    "errors": "please send the rating",
    "response_code": 201
}
=end

      def stone_parcel
        if current_customer
          stone_parcel = Stone.where(id: params[:id]).first
          if stone_parcel.nil?
            errors = ['Parcel not found']
            render :json => {:errors => errors, response_code: 201}
          else
            stone_rating = StoneRating.where(stone_id: stone_parcel.id, customer_id: current_customer.id).first
            if stone_rating.nil?
              stone_rating = StoneRating.new(comments: params[:comments], valuation: params[:valuation], parcel_rating: params[:parcel_rating], stone_id: stone_parcel.id, customer_id: current_customer.id)
            else
              stone_rating.comments = params[:comments] unless params[:comments].blank?
              stone_rating.parcel_rating = params[:parcel_rating] unless params[:parcel_rating].blank?
              stone_rating.valuation = params[:valuation] unless params[:valuation].blank?
            end
            if stone_rating.comments.present? || stone_rating.parcel_rating.present? || stone_rating.valuation.present?
              if stone_rating.save
                render :json => {stone_parcel: rating_stone_parcel(stone_rating), response_code: 200}
              else
                render :json => {:errors => stone_rating.errors.full_messages, response_code: 201}
              end
            else
              render json: {errors: "please send the rating", response_code: 201}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}, status: :unauthorized
        end
      end


=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/find_active_parcels?term=17.37
 @apiSampleRequest off
 @apiName find active parcels
 @apiGroup Tenders
 @apiDescription search in active parcels
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "parcels": [],
    "response_code": 200
}
=end

      def find_active_parcels
        if params[:term].nil? || params[:term].blank?
          render json: {errors: "Invalid Parameters", response_code: 201}
        else
          terms = params[:term].split(' ').map(&:to_f).delete_if {|i| i==0.0}
          @parcels = []
          begin
            terms.each do |term|
              @parcels << Stone.active_parcels(term)
            end
          rescue => e
            render json: {success: true, error: 'Something went wrong. Please try again with different image.', response_code: 201}
          else
            render json: {success: true, parcels: active_parcel_data(@parcels.flatten), response_code: 200}
          end
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/tender_winners?tender_id=1
 @apiSampleRequest off
 @apiName tender winners
 @apiGroup Tenders
 @apiDescription Tender winner list
 @apiSuccessExample {json} SuccessResponse:
{
    "tender_winners": [],
    "response_code": 200
}
=end

      def tender_winners
        tender_winners = TenderWinner.where(tender_id: params[:tender_id])
        if tender_winners.empty?
          render json: {tender_winners: [], response_code: 200}
        else
          render json: {tender_winners: tender_winners_data(tender_winners), response_code: 200}
        end
      end

      def tender_data(tenders)
        @data = []
        if current_customer
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: tender.check_notification(current_customer),
                ##tender_parcels: stone_data(tender.stones)
            }
          end
          @data
        else
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: false,
                #tender_parcels: stone_data(tender.stones)
            }
          end
          @data
        end
      end

      def old_tender_data(tenders)
        @data = []
        if current_customer
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: tender.check_notification(current_customer)
            }
          end
          @data
        else
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: false
            }
          end
          @data
        end
      end

      def winners_stone_data(stones)
        @stones = []
        stones.each do |stone|
          stone_rating = StoneRating.where(customer_id: current_customer.try(:id), stone_id: stone.id).first
          @stones << {
              id: stone.id,
              stone_type: stone.stone_type,
              no_of_stones: stone.no_of_stones,
              :size => stone.size,
              :weight => stone.weight,
              :purity => stone.purity,
              :color => stone.color,
              :polished => stone.polished,
              :deec_no => stone.deec_no,
              :lot_no => stone.lot_no,
              :description => stone.description,
              :comments => stone_rating.try(:comments),
              :valuation => stone_rating.try(:valuation),
              :parcel_rating => stone_rating.try(:parcel_rating),
              :images => parcel_images(stone),
              :winners_data => historical_data(stone.try(:tender).try(:id), stone)
          }
        end
        @stones
      end

      def stone_data(stones)
        @stones = []
        stones.each do |stone|
          stone_rating = stone.stone_ratings.where(customer_id: current_customer.try(&:id)).last
          stone_image = stone.parcel_images.where(customer_id: current_customer.try(&:id)).last
          @stone_wish_list = stone.wish_lists.where(customer_id: current_customer.try(&:id)).last

            @stones << {
              id: stone.id,
              stone_type: stone.stone_type,
              no_of_stones: stone.no_of_stones,
              size: stone.size,
              weight: stone.weight,
              purity: stone.purity,
              color: stone.color,
              polished: stone.polished,
              deec_no: stone.deec_no,
              lot_no: stone.lot_no,
              description: stone.description,
              comments: stone_rating.try(:comments),
              valuation: stone_rating.try(:valuation),
              wish_list_status: @stone_wish_list.present? ? @stone_wish_list.try(:wish_status): false,
              parcel_rating: stone_rating.try(:parcel_rating),
              images: parcel_images(stone),
              winners_data: historical_data(stone.try(:tender).try(:id), stone),
              highlight_parcel: stone_rating.present? || stone_image.present?
          }
        end
        @stones.sort_by{|e| e[:wish_list_status] ? 0 : 1}

      end

      def historical_data(id, stone)
        @w = []
        if stone.no_of_stones.to_i == 1
          # do nothing
        else
          desc = stone.description
          tender = current_customer.tenders.find(id) rescue Tender.find(id)
          tenders = Tender.includes(:tender_winners).where("id != ? and supplier_mine_id = ? and date(close_date) < ?", tender.id, tender.supplier_mine_id, tender.open_date.to_date).order("open_date DESC").limit(5)
          # winners = TenderWinner.includes(:tender).where("tender_id in (?) and tender_winners.description = ?", tenders.collect(&:id), desc)
          tender_winner_array = TenderWinner.includes(:tender).where(description: desc, tender_id: tenders.collect(&:id)).order("avg_selling_price desc").group_by {|t| t.tender.close_date.beginning_of_month}
          @winners = []
          tender_winner_array.each_pair do |tender_winner|
            @winners << tender_winner.try(:last).try(:first)
          end
          @winners = @winners.compact.sort_by {|e| e.tender.open_date}.reverse

          @winners.each do |winner|
            @w << {
                tender_id: winner.tender_id,
                lot_no: winner.lot_no,
                selling_price: winner.selling_price,
                created_at: winner.created_at,
                updated_at: winner.updated_at,
                description: winner.description,
                avg_selling_price: winner.avg_selling_price
            }
          end
        end
        @w
      end

      def active_parcel_data(stones)
        @stones = []
        duplicate_stones = stones.select {|item| stones.count(item) > 1}.uniq
        if duplicate_stones.empty?
          stones = stones
        else
          stones = duplicate_stones
        end
        stones.each do |stone|
          stone_rating = StoneRating.where(customer_id: current_customer.try(:id), stone_id: stone.id).first
          @stones << {
              id: stone.id,
              :description => stone.description,
              created_at: stone.created_at,
              updated_at: stone.updated_at,
              stone_type: stone.stone_type,
              no_of_stones: stone.no_of_stones,
              :size => stone.size,
              :weight => stone.weight,
              :purity => stone.purity,
              :color => stone.color,
              :polished => stone.polished,
              :deec_no => stone.deec_no,
              :lot_no => stone.lot_no,
              :comments => stone_rating.try(:comments),
              :valuation => stone_rating.try(:valuation),
              :parcel_rating => stone_rating.try(:parcel_rating),
              :tender_name => stone.name
          }
        end
        @stones
      end

      def tender_winners_data(tender_winners)
        winners = []
        tender_winners.each do |winner|
          stone = Stone.where(tender_id: winner.tender_id, lot_no: winner.lot_no).first
          unless stone.nil?
            winners << {
                description: winner.description,
                weight: stone.try(:weight),
                comments: stone.comments,
                valuation: stone.valuation,
                parcel_rating: stone.parcel_rating,
                size: stone.size,
                purity: stone.purity,
                color: stone.color,
                polished: stone.polished,
                deec_no: stone.deec_no,
                lot_no: stone.lot_no,
                selling_price: winner.selling_price,
                avg_selling_price: winner.avg_selling_price,
                tender_name: winner.tender.name
            }
          end
        end
        winners
      end

      def closed_tender_data(tenders)
        @data = []
        if current_customer
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: tender.check_notification(current_customer)
            }
          end
          @data
        else
          tenders.each do |tender|
            @data << {
                id: tender.id,
                name: tender.name,
                start_date: tender.open_date,
                end_date: tender.close_date,
                company_name: tender.supplier.try(:name),
                company_logo: nil,
                city: tender.city,
                country: tender.country,
                notification: false
            }
          end
          @data
        end
      end

      def rating_stone_parcel(stone_rating)
        stone = stone_rating.stone
        {
            id: stone.id,
            comments: stone_rating.comments,
            valuation: stone_rating.valuation,
            parcel_rating: stone_rating.parcel_rating,
            lot_no: stone.lot_no,
            tender_id: stone.tender_id,
            description: stone.description,
            no_of_stones: stone.no_of_stones,
            weight: stone.weight,
            carat: stone.carat,
            stone_type: stone.stone_type,
            size: stone.size,
            purity: stone.purity,
            color: stone.color,
            polished: stone.polished,
            created_at: stone.created_at,
            updated_at: stone.updated_at,
            deec_no: stone.deec_no,
            system_price: stone.system_price,
            lot_permission: stone.lot_permission,
            reserved_price: stone.reserved_price,
            yes_no_system_price: stone.yes_no_system_price,
            stone_winning_price: stone.stone_winning_price
        }
      end

      def parcel_images(stone)
        if current_customer
          stone.parcel_images.where(customer_id: current_customer.id).map {|e| e.try(:image_url)}.compact
        else
          []
        end
      end
    end
  end
end