module Api
  module V1
    class DemandsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :destroy]

      def index
        if current_company
          @all_demands = []
          @demand_suppliers = DemandSupplier.all
          DemandSupplier.all.each do |supplier|
            demands = Demand.where(company_id: current_company.id, demand_supplier_id: supplier.id, deleted: false)
            demand_supplier = {
              id: supplier.id,
              name: supplier.name,
              demands: demands
            }
            @all_demands << demand_supplier
          end
          respond_to do |format|
            format.json { render :index }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def create
        if current_company
          demand = Demand.new(company_id: current_company.id, demand_supplier_id: params[:demand_supplier_id], description: params[:description], block: false)
          if demand.save
            render json: { success: true, message: 'Demand created successfully.', demand: demand }
          else
            render json: { success: false, message: demand.errors.full_messages.first }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def destroy
        if current_company
          demand = Demand.where(id: params[:id]).first
          if demand.nil?
            render json: { success: false, message: 'Demand does not exist' }
          else
            if demand.update_attributes(deleted: true)
              render json: { success: true, message: 'Demand destroy successfully'}
            else
              render json: { success: false, message: demand.errors.full_messages }
            end
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def demand_suppliers
        demand_supplier = DemandSupplier.all
        render json: { success: true, demand_suppliers: demand_supplier.as_json(only: [:id, :name]), response_code: 200 }
      end

      def demand_description
        list = DemandList.where(demand_supplier_id: params[:demand_supplier_id])
        render json: { success: true, descriptions: list.map { |e| e.description }, response_code: 200 }
      end

      def parcels_list
        if current_company
          @demanded = []
          @others = []
          # Not showing Polished now
          parcels = TradingParcel.where(sold: false).where.not(description: 'Dummy Parcel for Demo - Please Delete', diamond_type: 'Polished')
          # parcels = TradingParcel.where(sold: false)
          required_parcels = []
          parcels.each do |parcel|
            if check_parcel_visibility(parcel, current_company)
              if parcel_demanded(parcel, current_company)
                @demanded << parcel_data(parcel, 'demanded')
              else
                @others << parcel_data(parcel, 'other')
              end
            end
          end
          render json: { success: true, parcels: { demanded: @demanded, others: @others }, response_code: 200 }
        else
          render json: { success: false, errors: "Not authenticated", response_code: 201 }
        end
      end

      def parcel_data(parcel, category)
        if parcel.company_id == current_company.id
          is_mine = true
        else
          is_mine = false
        end
        if current_company.has_overdue_transaction_of_30_days(parcel.try(:company_id)) || current_company.check_market_limit_overdue(get_market_limit(current_company, parcel.try(:company_id)), parcel.try(:company_id))
          is_overdue = true
        else
          is_overdue = false
        end
        @info = []
        parcel.parcel_size_infos.each do |i|
          size = i.size
          per = i.percent.to_f
          @info << { size: size, percent: per }
        end
        proposal = Proposal.where(buyer_id: current_company.id, trading_parcel_id: parcel.id).first
        if proposal.present?
          proposal_send = true
        else
          proposal_send = false
        end
        respose_hash =  {
          proposal_send: proposal_send,
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
          cost: parcel.cost,
          discount_per_month: parcel.box_value,
          sight: parcel.sight,
          source: parcel.source,
          uid: parcel.uid,
          percent:  parcel.try(:percent).to_f,
          comment: parcel.comment.to_s,
          total_value: parcel.try(:total_value).to_f,
          size_info: @info
        }

        if category == "demanded"
          demand = Demand.where(description: parcel.description, company_id: current_company.id).first
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
          render json: { success: true, live_demands: { rough: required_rough_demands, polished: required_polished_demands }, response_code: 200 }
        else
          render json: { success: false, errors: "Not authenticated", response_code: 201 }
        end
      end

    end
  end
end
