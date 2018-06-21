module Api
  module V1
    class DemandsController < ApiController
      skip_before_action :verify_authenticity_token, only: [:create]

      def index
        if current_company
          @dtc_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 1, deleted: false)
          @russian_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 2, deleted: false)
          @outside_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 3, deleted: false)
          @something_special_demands = Demand.where(company_id: current_company.id, demand_supplier_id: 4, deleted: false)
          # render json: {success: true, dtc: dtc_demands, russian: russian_demands, outside: outside_demands, something_special: something_special_demands, response_code: 200 }
          respond_to do |format|
            format.json { render :index, success: true}
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

      def create
        if current_company
          demand = Demand.new(company_id: current_company.id, demand_supplier_id: params[:demand_supplier_id], description: params[:description])
          if demand.save
            render json: { success: true, message: 'Demand created successfully...', demand: demand }
          else
            render json: { success: false, message: demand.errors.full_messages.first }
          end
        else
          render json: { errors: "Not authenticated", response_code: 201 }
        end
      end

    end
  end
end
