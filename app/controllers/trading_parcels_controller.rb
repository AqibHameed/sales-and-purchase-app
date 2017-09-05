class TradingParcelsController < ApplicationController
  before_action :set_trading_parcel, only: [:show]
  def show
  end

  private
  def set_trading_parcel
    @parcel = TradingParcel.find(params[:id])
  end
end