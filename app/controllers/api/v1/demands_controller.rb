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

      def parcels_list
       demand = Demand.where(id: params[:demand_id]).first
       if demand.present?
         parcels = TradingParcel.where(description: demand.description)
         detail = {
             description: demand.description,
             parcels: parcels
         }
         render json: { Demand_detail: detail }
       else
         render json: { success:false, message: 'This demand does not exists' }
       end
      end
    end
  end
end
