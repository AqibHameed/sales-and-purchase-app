class SuppliersController < ApplicationController
  layout 'supplier'
  before_action :authenticate_customer!

  def index
    @parcels = TradingParcel.where(customer_id: current_customer.id).order(created_at: :desc)
  end

  def trading
    @trading_document = TradingDocument.new
  end

  def parcels
    if params[:trading_document][:document].present?
      @trading_document = TradingDocument.new(trading_document_params)
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
  def trading_document_params
    params.require(:trading_document).permit(:company_id, :customer_id, :document, :credit_field, :lot_no_field, :desc_field, :no_of_stones_field, :sheet_no, :weight_field)
  end
end
