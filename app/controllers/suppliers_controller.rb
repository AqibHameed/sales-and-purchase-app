class SuppliersController < ApplicationController
  layout 'supplier'

  def index
  end

  def trading
    @trading_document = TradingDocument.new
  end

  def parcels
    @trading_document = TradingDocument.new(trading_document_params)
    if @trading_document.save
      redirect_to trading_suppliers_path
    else
      render :trading
    end
  end

  private
  def trading_document_params
    params.require(:trading_document).permit(:customer_id, :document, :credit_field, :lot_no_field, :desc_field, :no_of_stones_field, :sheet_no, :weight_field)
  end
end
