module Api
  module V1
    class DemandsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :destroy]
      include CustomersHelper

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
            format.json { render :index, success: true}
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def create
        if current_company
          demand = Demand.new(company_id: current_company.id, demand_supplier_id: params[:demand_supplier_id], description: params[:description], block: false)
          if demand.save
            render json: { success: true, message: 'Demand created successfully...', demand: demand }
          else
            render json: { success: false, message: demand.errors.full_messages.first }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def destroy
        if current_company
          demand = Demand.find_by(id: params[:id])
          if demand.update(deleted: true)
            render json: { success: true, message: 'Demand destroy successfully...'}
          else
            render json: { success: false, message: demand.errors.full_messages.first }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def demand_suppliers
        demand_supplier = DemandSupplier.all
        render json: { demand_suppliers: demand_supplier.as_json(only: [:id, :name]) }
      end

      def demand_description
        list = DemandList.where(demand_supplier_id: params[:demand_supplier_id])
        render json: { descriptions: list.map { |e| e.description } }
      end

      def parcels_list
        if current_company
          @demanded = []
          @others = []
          parcels = TradingParcel.where(sold: false)
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
          render json: { parcels: { demanded: @demanded, others: @others }}
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def parcel_data(parcel, category)
        respose_hash =  {
          id: parcel.id.to_s,
          description: parcel.description,
          lot_no: parcel.lot_no.to_s,
          no_of_stones: parcel.no_of_stones.to_s,
          carats: parcel.weight.to_s,
          credit_period: parcel.credit_period.to_s,
          avg_price: parcel.price.to_s,
          company: parcel.try(:company).try(:name),
          cost: parcel.cost.to_s,
          discount_per_month: parcel.box_value.to_s,
          sight: parcel.sight,
          source: parcel.source,
          uid: parcel.uid,
          percent: parcel.percent.to_s,
          comment: parcel.comment.to_s,
          total_value: parcel.total_value.to_s
        }
        if category == "demanded"
          demand = Demand.where(description: parcel.description, company_id: current_company.id).first
          respose_hash.merge(demand_id: demand.id)
        else
          respose_hash
        end
      end
    end
  end
end
