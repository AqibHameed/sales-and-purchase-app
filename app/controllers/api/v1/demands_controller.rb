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

      def demand_suppliers
        demand_supplier = DemandSupplier.all
        render json: {success: true, demand_suppliers: demand_supplier.as_json(only: [:id, :name]), response_code: 200}
      end

      def demand_description
        list = DemandList.where(demand_supplier_id: params[:demand_supplier_id])
        render json: {success: true, descriptions: list.map {|e| e.description}, response_code: 200}
      end

      def parcels_list
        if current_company
          @demanded = []
          source = DemandSupplier.where(id: params[:demand_supplier_id]).first.name if params[:demand_supplier_id].present?
          parcels = get_trading_pracels(source, params[:description], params[:parcel_id])
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
        if parcel.company_id == current_company.id
          is_mine = true
        else
          is_mine = false
        end
        is_overdue = false
        can_buy = true
        requested = nil
        if current_company.has_overdue_transaction_of_30_days(parcel.try(:company_id))
          is_overdue = true
          can_buy = false
          if Message.check_parcel_request(current_company.id, parcel)
            requested = true
            message = "You already requested"
          else
            message = "You don't meet days limit."
          end
        end

        if current_company.check_market_limit_overdue(get_market_limit(current_company, parcel.try(:company_id)), parcel.try(:company_id))
          is_overdue = true
          can_buy = false
          if Message.check_parcel_request(current_company.id, parcel)
            requested = true
            message = "You already requested"
          else
            message = "You don't meet market limit."
          end
        end
        @info = []
        parcel.parcel_size_infos.each do |i|
          size = i.size
          per = i.percent.to_f
          @info << {size: size, percent: per}
        end

        proposal = parcel.proposals.where(buyer_id: current_company.id).last
        if proposal.present?
          proposal_send = true
          proposal_status = proposal.status #negotiation_status(current_company)

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
            cost: parcel.cost.to_f,
            discount_per_month: parcel.box_value,
            sight: parcel.sight,
            source: parcel.source,
            uid: parcel.uid,
            percent: parcel.try(:percent).to_f,
            comment: parcel.comment.to_s,
            total_value: parcel.try(:total_value).to_f,
            size_info: @info,
            proposal_status: proposal_status,
            status: {
                can_buy: can_buy,
                requested: requested,
                message: message
            }
        }

        respose_hash.merge!(my_offer: my_offer) if my_offer

        if category == "demanded"
          #demand = Demand.where(description: parcel.description, company_id: current_company.id).first
          demand = current_company.demands.find_by(description: parcel.description)
          respose_hash.merge(demand_id: demand.id)
        else
          respose_hash
        end
      end

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
