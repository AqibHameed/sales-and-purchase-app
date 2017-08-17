class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy, :place_bid, :start_round, :round_completed]

  def index
    @auctions = Auction.all
  end

  def show
    if @auction.is_in_process?
      @last_round = @auction.auction_rounds.where(completed: true).sort_by(&:created_at).last
      @next_round = @auction.current_auction_round
    elsif @auction.is_ready_to_start?
      @auction.make_it_started
      move_to_next_round
    end
  end

  def round_completed
    if @auction.evaluating_round_id != params[:round].to_i
      @auction.update(evaluating_round_id: params[:round])
      @last_round = @auction.current_auction_round
      remove_lowest_bidder_for_the_last_round
      move_to_next_round unless @auction.completed?
    end
    redirect_to auction_path(@auction)
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

  def auction_completed?
    @last_round.bids.group_by(&:stone_id).keys.count == @last_round.round_winners.pluck(:stone_id).uniq.count
  end

  def highest_bid bids
    bids.group_by(&:total).sort.reverse.to_h.first[1].sort_by(&:created_at).first
  end

  def lowest_bids bids
    bids.group_by(&:total).sort.to_h.first[1]
  end

  def move_to_next_round
    @next_round = @auction.current_auction_round
    @next_round.update(started_at: Time.now) if @next_round.started_at.blank?
  end

  def only_single_customer_left_for_the_stone? bids, stone_id
    (bids.pluck(:customer_id) - @last_round.round_loosers.where(stone_id: stone_id).pluck(:customer_id)).length.eql?(1)
  end

  def remove_lowest_bidder_for_the_last_round
    @last_round.bids.group_by(&:stone_id).map do |stone_id, bids|
      lowest_bids(bids).each{ |bid| @last_round.add_round_looser(bid) }

      @last_round.add_round_winner(highest_bid(bids)) if only_single_customer_left_for_the_stone?(bids, stone_id)
    end

    @last_round.update(completed: true)

    @auction.make_it_completed if auction_completed?
  end

  private
    def set_auction
      @auction = Auction.find(params[:id])
    end

    def auction_params
      params.require(:auction).permit(:time, :min_bid, :tender_id, :round_time)
    end
end
