class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy, :place_bid, :start_round]

  def index
    @auctions = Auction.all
  end

  def show
    if @auction.started
      remove_lowest_bidder_for_the_last_round
      move_to_next_round
    elsif @auction.time <= Time.now
      @auction.update(started: true)
      move_to_next_round
    end
  end

  def remove_lowest_bidder_for_the_last_round
    @last_round = @auction.current_auction_round
    @last_round.update(completed: true)

    @last_round.bids.group_by(&:stone_id).map do |stone_id, bids|
      lowest_bids = bids.group_by(&:total).sort.to_h.first[1]
      lowest_bids.each{ |bid| @last_round.add_round_looser(bid) }
      round_winners if (bids.pluck(:customer_id) - @last_round.round_loosers.pluck(:customer_id).uniq).length.eql?(1)
    end

    (@last_round.bids.pluck(:customer_id).uniq - @last_round.round_loosers.pluck(:customer_id)).length

  end

  def move_to_next_round
    @next_round = @auction.current_auction_round
    @next_round.update(started_at: Time.now) if @next_round.started_at.blank?
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
      params.require(:auction).permit(:time, :min_bid, :tender_id, :round_time)
    end
end
