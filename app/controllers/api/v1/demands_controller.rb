module Api
  module V1
    class DemandsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create, :destroy]

      def index
        if current_company
          @dtc_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 1, deleted: false)
          @russian_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 2, deleted: false)
          @outside_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 3, deleted: false)
          @something_special_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 4, deleted: false)
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
        list = DemandList.where(demand_supplier_id: params[:demand_supplier_id])
        render json: { parcels_list: list.as_json(only: [:id, :description]) }
      end
    end
  end
end
