class SuppliersController < ApplicationController
  layout 'supplier'
  before_action :authenticate_customer!

  def index
    @parcels = TradingParcel.where(customer_id: current_customer.id).order(created_at: :desc).page params[:page]
  end

  def trading
    @trading_document = TradingDocument.new
    @trading_parcel = TradingParcel.new
  end

  def parcels
    if params[:trading_document][:document].present?
      if params[:trading_document][:diamond_type] == 'Rough'
        @trading_document = TradingDocument.new(rough_diamond_params)
      else
        @trading_document = TradingDocument.new(sight_diamond_params)
      end
      if @trading_document.save
        flash[:notice] = "Document uploaded successfully"
        redirect_to suppliers_path
      else
        render :trading
      end
    else
      flash[:notice] = "Please attach a document"
      redirect_to trading_suppliers_path
    end
  end

  private
  def sight_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :sheet_no, :weight_field, :sight_field, :source_field, :box_field, :cost_field, :box_value_field)
  end

  def rough_diamond_params
    params.require(:trading_document).permit(:diamond_type, :customer_id, :document, :credit_field, :price_field, :lot_no_field, :desc_field, :no_of_stones_field, :sheet_no, :weight_field)
  end
end
