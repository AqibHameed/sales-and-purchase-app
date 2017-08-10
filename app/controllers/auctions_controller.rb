class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy, :place_bid, :start_round]

  def index
    @auctions = Auction.all
  end

  def show
  end

  def new
    @auction = Auction.new
  end

  def edit
  end

  def create
    @auction = Auction.new(auction_params)

    if @auction.save
      redirect_to @auction, notice: 'Auction was successfully created.'
    else
      render :new
    end
  end

  def update
    if @auction.update(auction_params)
      redirect_to @auction, notice: 'Auction was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @auction.destroy
    redirect_to auctions_url, notice: 'Auction was successfully destroyed.'
  end

  def start_round
    @auction.auction_rounds.create()
  end

  def place_bid
    user_bid = @auction.current_auction_round.current_customer_bid_on_stone(current_customer, params[:stone_id])
    user_bid.total = params[:bid_amount]
    render json: { success: user_bid.save, msg: user_bid.save ? 'Bid placed successfully!' : user_bid.errors.full_messages }
  end

  private
    def set_auction
      @auction = Auction.find(params[:id])
    end

    def auction_params
      params.require(:auction).permit(:time, :min_bid, :tender_id)
    end
end
