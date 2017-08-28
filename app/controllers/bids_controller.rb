class BidsController < ApplicationController

  before_action :authenticate_admin!, :only => [:list, :tender_total, :tender_success, :tender_unsuccess]
  before_action :authenticate_logged_in_user!

  def create
    @stone = Stone.find(params[:stone_id])
    @bid = Bid.find_or_initialize_by(stone_id: params[:stone_id], customer_id: current_customer.id)
    @tender = @stone.tender
    @bid.total = params[:bid][:total]
    @bid.price_per_carat = params[:bid][:price_per_carat]
    if @bid.save
      respond_to do |format|
        format.js { render 'tenders/refresh_data.js.erb'}
        format.html {redirect_to @bid.stone.tender}
      end
    else
      puts @bid.errors.inspect
      respond_to do |format|
        format.js {render :text => 'Error'}
        format.html {redirect_to @bid.stone.tender}
      end
    end

  end

  def list
    @tenders = Tender.includes(:bids, :tender_winners).order("created_at desc").all
  end

  def tender_total
    @tender = Tender.find(params[:tender_id])
    past_tenders = Tender.where("id != ? and company_id = ? and date(open_date) < ?", @tender.id, @tender.company_id, @tender.open_date.to_date).order("open_date DESC").limit(5)
    @past_tenders = past_tenders ? past_tenders.collect(&:id) : []
    if params[:deec_no] || params[:lot_no] || params[:client_name] || params[:description]
      col_str = ""
      col_str =  "stones.deec_no = #{params[:deec_no]}"  unless params[:deec_no].blank?
      col_str += (col_str.blank?) ? "stones.lot_no =  #{params[:lot_no]}" : " OR stones.lot_no = #{params[:lot_no]}" unless params[:lot_no].blank?
      col_str += (col_str.blank?) ? "stones.description LIKE '%#{params[:description]}%'" : " AND stones.description LIKE '%#{params[:description]}%'" unless params[:description].blank?
      col_str += (col_str.blank?) ? "(customers.first_name LIKE '%#{params[:client_name]}%' OR customers.last_name LIKE '%#{params[:client_name]}%')" : " AND (customers.first_name LIKE '%#{params[:client_name]}%' OR customers.last_name LIKE '%#{params[:client_name]}%')" unless params[:client_name].blank?
      @bids = @tender.bids.joins(:stone, :customer).where(col_str)
    else
      @bids = @tender.bids.includes(:customer, :stone).order(:customer_id)
    end

    respond_to do |format|
      format.html
      format.js { render :json => @bids }
    end
  end

  def tender_success
    @tender = Tender.find(params[:tender_id])
    past_tenders = Tender.where("id != ? and company_id = ? and date(open_date) < ?",@tender.id, @tender.company_id, @tender.open_date.to_date).order("open_date DESC").limit(5)
    @past_tenders = past_tenders.any? ? past_tenders.collect(&:id) : []
    @bids = @tender.tender_successful_bids
    respond_to do |format|
      format.html
    end
  end

  def tender_unsuccess
    @tender = Tender.find(params[:tender_id])
    past_tenders = Tender.where("id != ? and company_id = ? and date(open_date) < ?", @tender.id, @tender.company_id, @tender.open_date.to_date).order("open_date DESC").limit(5)
    @past_tenders = past_tenders ? past_tenders.collect(&:id) : []
    success_bids = @tender.tender_successful_bids
    @bids = @tender.bids - success_bids
    respond_to do |format|
      format.html
    end
  end

  def parcel_report
    @tender = Tender.find_by_id(params[:tender])
    past_tenders = Tender.where("id != ? and company_id = ? and date(open_date) < ?", @tender.id, @tender.company_id, @tender.open_date.to_date).order("open_date DESC")
    @past_tenders = past_tenders ? past_tenders.collect(&:id) : []
    @bid = Bid.find_by_id(params[:bid])
    # bids = Bid.where(:stone_id => @bid.stone.id, :tender_id => @bid.tender.id).order('total desc')

    #################### Graph Data #################
    @history = TenderWinner.where("tender_id in (?) and description = ?", past_tenders.collect(&:id), @bid.stone.description).order("tender_id")

    @stones = Stone.where("description = ? and tender_id in (?)", @bid.stone.description, past_tenders.collect(&:id))
    @bid_history = Bid.where("tender_id in (?) and stone_id in (?) and customer_id is NOT NULL", past_tenders.collect(&:id), @stones.collect(&:id)).order("total desc")

    if @bid_history.any?
      @bids =  @bid_history
      my_list = {}
      @bid_history.each do |b|
        my_list[b.tender_id] = b.price_per_carat
      end
      @my_bid_list = []
      @history.each do |h|
        @my_bid_list << (my_list[h.tender_id].nil? ? 0 : my_list[h.tender_id])
      end
    end
    client_stone = Stone.find_by_id(params[:stone])
    @top_client_bids = client_stone ? client_stone.bids.where(:tender_id => @tender.id).order("price_per_carat desc") : []
    @highest_bid = @top_client_bids.any? ? @top_client_bids.first.total : 0

    @past_winner = @history.last
    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  def update
    @bid = Bid.find(params[:id])
    @stone = @bid.stone
    @tender = @bid.stone.tender
    if @bid.update_attributes(params[:bid])
      respond_to do |format|
        format.js { render 'tenders/refresh_data.js.erb'}
        format.html {redirect_to @bid.stone.tender}
      end
    else
      puts @bid.errors.inspect
      respond_to do |format|
        format.js {render :text => 'Error'}
        format.html {redirect_to @bid.stone.tender}
      end
    end
  end

  def place_new
    @stone = Stone.find(params[:stone_id])
    tender = @stone.tender
    # past_tenders = Tender.where("id != ? and company_id = ? and date(open_date) < ?", tender.id, tender.company_id, tender.open_date.to_date).order("open_date DESC").limit(5)
    past_tenders = Tender.where("id != ? and company_id = ? and date(close_date) < ?", tender.id, tender.company_id, tender.open_date.to_date).order("open_date DESC").limit(5)
    past_tender = past_tenders.first
    # @history = TenderWinner.where("tender_id in (?) and description = ?", past_tenders.collect(&:id), @stone.description).order("tender_id")
    history_array = TenderWinner.includes(:tender).where(description: @stone.description, tender_id: past_tenders.collect(&:id)).order("avg_selling_price desc").group_by { |t| t.tender.close_date.beginning_of_month }
    @history = []
    history_array.each_pair do |ha|
      @history << ha.try(:last).try(:first)
    end
    @history = @history.compact.sort_by{|e| e.tender.open_date}.reverse
    stones = Stone.where("description = ? and tender_id in (?)", @stone.description, past_tenders.collect(&:id))
    bid_history = Bid.where("tender_id in (?) and customer_id = ? and stone_id in (?)", past_tenders.collect(&:id), current_customer.id, stones.collect(&:id)).order("tender_id")
    my_list = {}
    bid_history.each do |b|
      my_list[b.tender_id] = b.price_per_carat
    end
    @my_bid_list = []
    @history.each do |h|
      @my_bid_list << (my_list[h.tender_id].nil? ? 0 : my_list[h.tender_id])
    end
    @past_winner = @history.last
    logger.info "---------------------------------"
    logger.info @my_bid_list
    logger.info "---------------------------------"
    @bid = Bid.find_or_initialize_by(stone_id: params[:stone_id], customer_id: current_customer.id)
    render :partial => 'place_new'
  end
end

