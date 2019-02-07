module Api
  module V1
    class DemandsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :destroy]

      # def index
      #   if current_company
      #     demands = Demand.where(company_id: current_company.id, deleted: false)
      #     demands = demands.where(demand_supplier_id: params[:supplier_id]) if params[:supplier_id].present?
      #     @demands = demands.page(params[:page]).per(params[:count])
      #     render json: { pagination: set_pagination(:demands), demands: demands_data(@demands), response_code: 200 }
      #   else
      #     render json: { errors: "Not authenticated", response_code: 201 }
      #   end
      # end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/demands
 @apiSampleRequest off
 @apiName index
 @apiGroup Demands
 @apiDescription show list of demands
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "response_code": 200,
    "demands": [
        {
            "id": 1,
            "name": "Sight",
            "descriptions": [
                {
                    "id": 10744,
                    "description": "Dummy Parcel for Demo",
                    "parcels": 0
                }
            ]
        },
        {
            "id": 2,
            "name": "RUSSIAN",
            "descriptions": [
                {
                    "id": 10745,
                    "description": "Dummy Parcel for Demo",
                    "parcels": 0
                }
            ]
        },
        {
            "id": 3,
            "name": "OUTSIDE",
            "descriptions": [
                {
                    "id": 10746,
                    "description": "Dummy Parcel for Demo",
                    "parcels": 1
                }
            ]
        },
        {
            "id": 4,
            "name": "POLISHED",
            "descriptions": []
        }
    ]
}
=end

      def index
        if current_company
          @all_demands = []
          @demand_suppliers = DemandSupplier.all
          DemandSupplier.all.each do |supplier|
            demands = Demand.where(company_id: current_company.id, demand_supplier_id: supplier.id, deleted: false)
            demand_h = []
            demands.each do |demand|
              parcels = current_company.trading_parcels.where(sold: false).where("source LIKE ? ", supplier.name).where("description LIKE ? ", demand.description)
              demand_h << {
                  id: demand.id,
                  description: demand.description,
                  parcels: parcels.count
              }
            end
            demand_supplier = {
                id: supplier.id,
                name: supplier.name,
                demands: demand_h
            }
            @all_demands << demand_supplier
          end
          respond_to do |format|
            format.json {render :index}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {post} /api/v1/demands?demand_supplier_id=4&description[]=PINKCOLOR&description[]=BLUECOLOR
 @apiSampleRequest off
 @apiName create
 @apiGroup Demands
 @apiDescription Create demands
 @apiParamExample {json} Request-Example:
nothing only params in url
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Demand created successfully.",
    "demands": {
        "id": 10820,
        "description": "BLUE COLOR",
        "weight": null,
        "price": null,
        "company_id": 3585,
        "diamond_type": null,
        "created_at": "2018-12-18T12:10:58.000Z",
        "updated_at": "2018-12-18T12:10:58.000Z",
        "demand_supplier_id": 4,
        "block": false,
        "deleted": false
    }
}
=end


      def create
        if current_company
          array = []
          descriptions = params[:description]
          descriptions.each do |d|
            @demands = Demand.where(company_id: current_company.id, demand_supplier_id: params[:demand_supplier_id], description: d, block: false).first_or_create
          end
          if @demands.present?
            render json: {success: true, message: 'Demand created successfully.', demands: @demands}
          else
            render json: {success: false, message: @demands.errors.full_messages.first}
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end


=begin
 @apiVersion 1.0.0
 @api {delete} /api/v1/demands/10820
 @apiSampleRequest off
 @apiName destroy
 @apiGroup Demands
 @apiDescription Delete demand with demnad_id = 10820
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "message": "Demand destroy successfully"
}
=end

      def destroy
        if current_company
          demand = Demand.where(id: params[:id]).first
          if demand.nil?
            render json: {success: false, message: 'Demand does not exist'}
          else
            if demand.update_attributes(deleted: true)
              render json: {success: true, message: 'Demand destroy successfully'}
            else
              render json: {success: false, message: demand.errors.full_messages}
            end
          end
        else
          render json: {errors: "Not authenticated", response_code: 201}
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/demands/demand_suppliers
 @apiSampleRequest off
 @apiName demand_suppliers
 @apiGroup Demands
 @apiDescription show demand sources
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "demand_suppliers": [
        {
            "id": 1,
            "name": "Sight"
        },
        {
            "id": 2,
            "name": "RUSSIAN"
        },
        {
            "id": 3,
            "name": "OUTSIDE"
        },
        {
            "id": 4,
            "name": "SPECIAL"
        },
        {
            "id": 5,
            "name": "POLISHED"
        }
    ],
    "response_code": 200
}
=end

      def demand_suppliers
        demand_supplier = DemandSupplier.all
        render json: {success: true, demand_suppliers: demand_supplier.as_json(only: [:id, :name]), response_code: 200}
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/demands/demand_description
 @apiSampleRequest off
 @apiName demand description
 @apiGroup Demands
 @apiDescription show demand description
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "descriptions": [
        "Z -7+5",
        "Z -7",
        "Z -5+3",
        "Z 3 grs +7 (mele)",
        "Z 3 grs (mele)",
        "Z -3",
        "Z +9 (mele)",
        "Z +7 (mele)",
        "Z +11 (mele)",
        "Z / Longs 3grs / +7",
        "Z / Longs 3 grs",
        "Z / Longs -11+9",
        "Z / Longs +7",
        "Z / Longs +11",
        "Z / Cliv -2 grs+3",
        "Z / Cliv 11+9",
        "Z / Cliv +7",
        "Z / Cliv +5",
        "Z / Cliv +3",
        "Z / Cliv +11"
    ],
    "response_code": 200
}
=end


      def demand_description
        list = DemandList.where(demand_supplier_id: params[:demand_supplier_id])
        render json: {success: true, descriptions: list.map {|e| e.description}, response_code: 200}
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/demands/parcels_list
 @apiSampleRequest off
 @apiName parcels list
 @apiGroup Demands
 @apiDescription show parcel list
 @apiSuccessExample {json} SuccessResponse:
{
    "pagination": {
        "total_pages": 1,
        "prev_page": null,
        "next_page": null,
        "current_page": 1
    },
    "parcels": [
        {
            "proposal_send": false,
            "proposal_id": null,
            "is_mine": false,
            "is_overdue": true,
            "id": "147",
            "description": "Collection 5-10 ct",
            "lot_no": null,
            "no_of_stones": 10,
            "carats": 1,
            "credit_period": 15,
            "avg_price": 3000,
            "company": "Seller B",
            "rank": null,
            "cost": null,
            "discount_per_month": null,
            "sight": "12/2018",
            "source": "DTC",
            "uid": "7acec9df",
            "percent": 10,
            "comment": "",
            "total_value": 3000,
            "size_info": [],
            "proposal_status": "no",
            "my_offer": null,
            "demand_id": 61
        },
        {
            "proposal_send": false,
            "proposal_id": null,
            "is_mine": true,
            "is_overdue": true,
            "id": "155",
            "description": "Collection 5-10 ct",
            "lot_no": null,
            "no_of_stones": 10,
            "carats": 1,
            "credit_period": 3000,
            "avg_price": 3000,
            "company": "Dummy Seller 1",
            "rank": null,
            "cost": null,
            "discount_per_month": "0",
            "sight": "12/18",
            "source": "DTC",
            "uid": "a98d1901",
            "percent": 0,
            "comment": "",
            "total_value": 3000,
            "size_info": [],
            "proposal_status": "no",
            "my_offer": null,
            "demand_id": 61
        }
    ],
    "response_code": 200
  }
=end

      def parcels_list
        if current_company
          @demanded = []
          companies_total_scores = []
          source = DemandSupplier.where(id: params[:demand_supplier_id]).first.name if params[:demand_supplier_id].present?
          parcels = get_trading_pracels(source, params[:description], params[:parcel_id])
          parcels.each do |parcel|
            companies_total_scores << parcel.try(:company).get_seller_score
          end
          update_seller_score_rank(companies_total_scores)
          parcels.each do |parcel|
            if check_parcel_visibility(parcel, current_company)
              if parcel_demanded(parcel, current_company)
                @demanded << parcel_data(parcel, 'demanded')
              end
            end
          end
          @all_parcels = Kaminari.paginate_array(@demanded).page(params[:page]).per(params[:count])
          render json: {pagination: set_pagination(:all_parcels), parcels: @all_parcels, response_code: 200}
        else
          render json: {success: false, errors: "Not authenticated", response_code: 201}
        end
      end

      def parcel_data(parcel, category)
        seller_score = SellerScore.find_by(company_id: parcel.try(:company).id)
        if parcel.company_id == current_company.id
          is_mine = true
        else
          is_mine = false
        end
        is_overdue = false
        if current_company.has_overdue_transaction_of_30_days(parcel.try(:company_id))
          is_overdue = true
        end

        # if current_company.check_market_limit_overdue(get_market_limit(current_company, parcel.try(:company_id)), parcel.try(:company_id))
        #   is_overdue = true
        # end
        @info = []
        parcel.parcel_size_infos.each do |i|
          size = i.size
          per = i.percent.to_f
          @info << {size: size, percent: per}
        end

        proposal = parcel.proposals.where('buyer_id = ? AND status != ?', current_company.id, 2).last
        if proposal.present?
          proposal_send = true
          proposal_status = proposal.status #negotiation_status(current_company)
          my_offer = nil
          if proposal.new_proposal?
            negotiation = proposal.negotiations.find_by(from: 'buyer')
            if negotiation
              my_offer = {
                  id: negotiation.id,
                  offered_percent: negotiation.percent.to_f,
                  offered_credit: negotiation.credit,
                  offered_price: negotiation.price.to_f,
                  offered_total_value: negotiation.total_value.to_f,
                  offered_comment: negotiation.comment,
                  offered_from: negotiation.from,
                  is_mine: negotiation.whose == current_company
              }
            end
          end
        else
          proposal_send = false
          proposal_status = 'no'
        end
        respose_hash = {
            proposal_send: proposal_send,
            proposal_id: proposal.try(:id),
            is_mine: is_mine,
            is_overdue: is_overdue,
            id: parcel.id.to_s,
            description: parcel.description,
            lot_no: parcel.lot_no,
            no_of_stones: parcel.no_of_stones,
            carats: parcel.try(:weight).to_f,
            credit_period: parcel.credit_period,
            avg_price: parcel.try(:price).to_f,
            company: parcel.try(:company).try(:name),
            rank: seller_score.rank,
            cost: parcel.cost,
            discount_per_month: parcel.box_value,
            sight: parcel.sight,
            source: parcel.source,
            uid: parcel.uid,
            percent: parcel.try(:percent).to_f,
            comment: parcel.comment.to_s,
            total_value: parcel.try(:total_value).to_f,
            size_info: @info,
            proposal_status: proposal_status
        }

        respose_hash.merge!(my_offer: my_offer)

        if category == "demanded"
          #demand = Demand.where(description: parcel.description, company_id: current_company.id).first
          demand = current_company.demands.find_by(description: parcel.description)
          respose_hash.merge(demand_id: demand.id)
        else
          respose_hash
        end
      end

      def update_seller_score_rank(companies_total_scores)
      final_score = companies_total_scores.map{|company_score| company_score if company_score.total != 0.0}.compact.sort_by(&:total)

      total_companies = companies_total_scores.count
      ten_percent = ((total_companies / 100.to_f) * 10)
      twenty_percent = ((total_companies / 100.to_f) * 20)
      fourty_percent = ((total_companies / 100.to_f) * 40)
      hundred_percent = ((total_companies / 100.to_f) * 100)

      percentile_rank(final_score, ten_percent, twenty_percent, fourty_percent, hundred_percent)
      end

      def percentile_rank(final_score, ten_percent, twenty_percent, fourty_percent, hundred_percent)
        rank = ''
        final_score.each do |percentage|
          if final_score.index(percentage) <= ten_percent
            rank = 10
          elsif final_score.index(percentage) > ten_percent && final_score.index(percentage) <= twenty_percent
            rank = 10
          elsif final_score.index(percentage) > twenty_percent && final_score.index(percentage) <= fourty_percent
            rank =  10
          elsif final_score.index(percentage) > fourty_percent && final_score.index(percentage) <= hundred_percent
            rank = 10
          end
          seller_score = SellerScore.find_by(company_id: percentage[:company_id])
          if seller_score.present?
            seller_score.update(rank: rank)
          end
        end
      end

=begin
 @apiVersion 1.0.0
 @api {get} /api/v1/demands/live_demands
 @apiSampleRequest off
 @apiName live demands
 @apiGroup Demands
 @apiDescription get live demands with authorization token
 @apiSuccessExample {json} SuccessResponse:
{
    "success": true,
    "live_demands": {
        "rough": [
            {
                "description": "PINK COLOR",
                "no_of_demands": 1,
                "date": "2018-12-18T12:10:58+00:00"
            }
        ],
        "polished": []
    },
    "response_code": 200
}
=end

      def live_demands
        if current_company
          required_rough_demands = []
          required_polished_demands = []
          ids = current_company.block_users
          @normal_demands = Demand.where('created_at > ?', 30.days.ago).where.not(company_id: ids).order(created_at: :desc)
          @polished_demands = PolishedDemand.where('created_at > ?', 30.days.ago).where.not(company_id: ids).order(created_at: :desc)
          @normal_demands.group_by(&:description).each do |description, parcels|
            data = {
                description: description,
                no_of_demands: parcels.count,
                date: get_last_demand_date(parcels).strftime("%FT%T%:z")
            }
            required_rough_demands << data
          end
          @polished_demands.each do |p|
            data = {
                id: p.id,
                demand_supplier_id: p.demand_supplier_id,
                company_id: p.company_id,
                description: p.description,
                weight_from: p.weight_from,
                price: p.price,
                block: p.block,
                deleted: p.deleted,
                shape: p.shape,
                color_from: p.color_from,
                clarity_from: p.clarity_from,
                cut_from: p.cut_from,
                polish_from: p.polish_from,
                symmetry_from: p.symmetry_from,
                fluorescence_from: p.fluorescence_from,
                lab: p.lab,
                city: p.city,
                country: p.country,
                created_at: p.created_at.strftime("%FT%T%:z"),
                updated_at: p.updated_at.strftime("%FT%T%:z"),
                weight_to: p.weight_to,
                color_to: p.color_to,
                clarity_to: p.clarity_to,
                cut_to: p.cut_to,
                polish_to: p.polish_to,
                symmetry_to: p.symmetry_to,
                fluorescence_to: p.fluorescence_to
            }
            required_polished_demands << data
          end
          render json: {success: true, live_demands: {rough: required_rough_demands, polished: required_polished_demands}, response_code: 200}
        else
          render json: {success: false, errors: "Not authenticated", response_code: 201}
        end
      end

      private

      def demands_data(demands)
        @data = []
        demands.each do |demand|
          data = {
              id: demand.id,
              description: demand.description,
              company_id: demand.company_id,
              created_at: demand.created_at,
              updated_at: demand.updated_at,
              demand_supplier_id: demand.demand_supplier_id
          }
          @data << data
        end
        @data
      end
    end
  end
end
