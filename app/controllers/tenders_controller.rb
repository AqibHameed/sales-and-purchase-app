class TendersController < ApplicationController

  protect_from_forgery :except => [:filter, :temp_filter, :add_rating]

  before_action :authenticate_logged_in_user!, :only => [:index, :history, :show, :filter, :view_past_result]
  before_action :authenticate_customer!, :except => [:index, :history, :delete_stones,:delete_winner_details, :show, :filter, :view_past_result, :admin_details, :admin_winner_details, :update_stone_desc, :update_winner_desc, :winner_list,:bidder_list,:customer_bid_list,:customer_bid_detail ]
  before_action :authenticate_admin!, :only => [:delete_stones,:delete_winner_details, :admin_details, :admin_winner_details, :update_stone_desc, :update_winner_desc, :winner_list,:bidder_list,:customer_bid_list,:customer_bid_detail]

  layout :false, :only => [:admin_details, :admin_winner_details]

  def new
    @tender = Tender.new
  end

  def create
    @company= Company.find(params[:search_company])
    @tender = @company.tenders.new(tender_params)
    if @tender.save
      @stone = @tender.stones.create(stone_type: params[:stone_type], no_of_stones: params[:no_of_stones], size: params[:size], weight: params[:weight], carat: params[:carat], deec_no: params[:deec_no], lot_no: params[:lot_no], description: params[:description], system_price: params[:system_price],lot_permission: params[:lot_permission])
      redirect_to root_path
    else
      render 'new'
    end
  end

  def block_lot
    stone = Stone.find(params[:id])
    a=params[:lot_permission]
    if( a=="YES")
      stone.lot_permission = true
      stone.save!
    else
      stone.lot_permission = false
      stone.save!
    end
  end

  def customer_bid_detail
    @tender = Tender.find(params[:id])
    @bids = Bid.where(["tender_id = ? and customer_id = ?",@tender.id, params[:customer_id]]).includes(:customer, :stone)
  end

  def customer_bid_list
    @tender = Tender.find(params[:id])
    @bids = Bid.where(["tender_id = ?",@tender.id]).order("customer_id, total desc").includes(:customer, :stone)
  end

  def winner_list
    @tender = Tender.find(params[:id])
  end

  def bidder_list
    @tender = Tender.find(params[:id])
    @stone = Stone.find(params[:stone_id])
    @bids = Bid.where(["tender_id = ? and stone_id = ?",@tender.id,params[:stone_id]]).order("total desc").includes(:customer, :stone)
  end

  def admin_details
    @tender = Tender.find(params[:id])
    @past_details = @tender.past_details
    @past_winners = @tender.past_winners
    @stones = @tender.stones
  end

  def admin_winner_details
    @tender = Tender.find(params[:id])
    @past_details = @tender.past_details
    @past_winners = @tender.past_winners
    @winners = @tender.tender_winners
  end

  def index
    col_str = ""
    upcomimg_str = "open_date > '#{Time.zone.now}'"
    if params[:comapany] || params[:tender] || params[:status]
      col_str =  "tenders.name LIKE '%#{params[:tender]}%'"  unless params[:tender].blank?
      col_str += (col_str.blank?) ? "tenders.company_id =  #{params[:company]}" : " AND tenders.company_id = #{params[:company]}" unless params[:company].blank?
      col_str += (col_str.blank?) ? ((params[:status] == '0') ? ("tenders.close_date < DATE(NOW())") : ("close_date > DATE(NOW())")) : ((params[:status] == '0') ? (" AND tenders.close_date < DATE(NOW())") : (" AND close_date > DATE(NOW())")) unless params[:status].blank?
    end
    if current_customer
      @tenders = current_customer.tenders.active.where(col_str).order("created_at desc").page params[:page]
      @upcoming_tenders = current_customer.tenders.where(upcomimg_str).where(col_str).order("created_at desc").page params[:page]
    else
      @tenders = Tender.active.where(col_str).order("created_at desc").page params[:page]
      @upcoming_tenders = Tender.where(upcomimg_str).where(col_str).order("created_at desc").page params[:page]  
    end
    @news = News.first(10)
  end

  def show
    if current_customer
      @tender = current_customer.tenders.includes(:stones).find(params[:id])
      # @notes = current_customer.notes.where(tender_id: @tender.id).collect(&:key)
      companies = current_customer.companies
      #@tender = companies.eager_load(tenders: [:stones]).where("tenders.id=#{params[:id].to_i}").first.try(:tenders).find(params[:id])
      if @tender.open_date < Time.now && Time.now < @tender.close_date
        @round = 1
      end
      @notes = current_customer.notes.where(tender_id: @tender.try(:id)).collect(&:key)
      flags = Rating.where(tender_id: @tender.id, customer_id: current_customer.id)
      # => Check for conflicts
      @important = []
      @read = []
      flags.each do |f|
        @important << f.key if f.flag_type == 'Imp'
        @read << f.key if f.flag_type == 'Read'
      end

      # past tender
      past_tenders = Tender.where("id != ? and company_id = ?", @tender.id, @tender.company_id).order("open_date DESC").limit(5)
      @last_tender = past_tender = past_tenders.first

      # my past tendet bids
      mpb = Bid.where("tender_id = ? and customer_id = ?", past_tender.id,current_customer.id) if past_tender
      my_past_bids = {}
      unless past_tender.nil?
        stones = {}
        past_tender.stones.each do |s|
          stones[s.id] = s.description
        end

        mpb.each do |mp|
          my_past_bids[stones[mp.stone_id]] = mp.price_per_carat
        end

        # system past tendet winners
        pws = TenderWinner.where(tender_id: past_tender.id)
        past_winners = {}

        pws.each do |pw|
          past_winners[pw.description] = pw.avg_selling_price
        end

        #diiference in my bids and winners
        @diff = {}
        graph = {'no' => 0, 'low' => 0, 'mid' => 0, 'high' => 0, 'vhigh' => 0 }
        past_winners.keys.each do |k|
          @diff[k] =   (100 - (my_past_bids[k] / past_winners[k] * 100)).round(1)  unless my_past_bids[k].nil?
          val = @diff[k].to_i.abs
          graph['no'] += 1 if val == 0
          graph['low'] += 1 if val <= 5 and val != 0
          graph['mid'] += 1 if val > 5 and val <= 15
          graph['high'] += 1 if val > 15 and val <= 25
          graph['vhigh'] += 1 if val > 25
        end

        @graph = [['Less than 5 %', graph['low']],['5 to 15 %', graph['mid']],['15 to 25 %', graph['high']],['More than 25 %', graph['vhigh']]]

      end
    else
      @tender = Tender.includes(:stones).find(params[:id])
    end
    @stones = @tender.stones
  end

  def add_note
    @tender = current_customer.tenders.find(params[:id])
    @key = params[:key]
    @note = Note.where(tender_id: @tender.id, key: @key, customer_id: current_customer.id).first

    render :partial => 'add_note'

  end

  def save_note
    @tender = current_customer.tenders.find(params[:id])
    @note = Note.find_or_initialize_by(tender_id: @tender.id, key: params[:key], customer_id: current_customer.id)
    @note.note = params[:note]
    @note.stone_id = params[:stone_id]
    @note.deec_no = params[:deec_no]
    @note.save

    respond_to do |format|
      format.js
    end

  end

  def add_rating

    r = Rating.find_or_initialize_by(tender_id: params[:id], customer_id: current_customer.id, key: params[:key], flag_type: 'Imp')

    if r.id.nil?
      r.save
      op =  "reloadRaty('#{params[:id_key]}','on')"
    else
      r.destroy
      op = "reloadRaty('#{params[:id_key]}','off')"
    end

    render :js => op

  end

  def add_read
    r = Rating.find_or_initialize_by(tender_id: params[:id], customer_id: current_customer.id, key: params[:key], flag_type: 'Read')

    if r.id.nil?
    r.save
    score = 1
    else
    r.destroy
    score = 0
    end

    render :js => "$('##{params[:id_key]}').prop('checked', this.checked);$('##{params[:id_key]}').next().html('#{score}');$('#myTable').trigger('update');"

  end

  def bid
    @tender = current_customer.tenders.includes(:stones).find(params[:id])
    @stones = @tender.stones
    @bid = Bid.find_or_initialize_by(customer_id: current_customer.id, tender_id: @tender.id)
  end

  def filter
    query = []
    if params[:filter]
      params[:filter].each do |f|
        case f['type']
        when 'DEEC No'
          query << "(deec_no >=  #{f['from']} and deec_no <= #{f['to']})" if (f['from'] != "" && f['to'] != "")
        when 'Lot No'
          query << "(lot_no >=  #{f['from']} and lot_no <= #{f['to']})" if (f['from'] != "" && f['to'] != "")
        when 'Carat'
          #query << "(carat between '#{f['from'].to_f}' and '#{f['to'].to_f}')"
          query << "(weight >= '#{f['from'].to_f}' and  weight <= '#{f['to'].to_f}')" if (f['from'] != "" && f['to'] != "")
        else
        end

      end

    end

    q = query.join(' or ')

    q = q + " #{query.length == 0 ? '' : 'and' } description like '%#{params[:search]}%'" unless params[:search].strip.blank?

    if current_customer

      @tender = current_customer.tenders.find(params[:id])
      @notes = current_customer.notes.where(tender_id: @tender.id).collect(&:key)

      @bid = Bid.find_or_initialize_by(customer_id: current_customer.id, tender_id: @tender.id)

      flags = Rating.where(tender_id: @tender.id, customer_id: current_customer.id)
      @important = []
      @read = []
      flags.each do |f|
        @important << f.key if f.flag_type == 'Imp'
        @read << f.key if f.flag_type == 'Read'
      end
    else
      @tender = Tender.find(params[:id])
    end
    @stones = @tender.stones.where(q)

    render 'show'

  end

  def temp_filter
    query = []
    if params[:filter]
      params[:filter].each do |f|
        case f['type']
        when 'Lot No'
          query << "(lot_no >=  #{f['from']} and lot_no <= #{f['to']})" if (f['from'] != "" && f['to'] != "")
        when 'Carat'
          #query << "(carat between '#{f['from'].to_f}' and '#{f['to'].to_f}')"
          query << "(carat >= '#{f['from'].to_f}' and  carat <= '#{f['to'].to_f}')" if (f['from'] != "" && f['to'] != "")
        else
        end
      end
    end

    q = query.join(' or ')

    q = q + " #{query.length == 0 ? '' : 'and' } description like '%#{params[:search]}%'" unless params[:search].strip.blank?

    @tender = current_customer.tenders.find(params[:id])
    @stones = @tender.temp_stones.where(q)
    @notes = current_customer.notes.where(tender_id: @tender.id).collect(&:key)

    flags = Rating.where(tender_id: @tender.id, customer_id: current_customer.id)
    @important = []
    @read = []
    flags.each do |f|
      @important << f.key if f.flag_type == 'Imp'
      @read << f.key if f.flag_type == 'Read'
    end

    render 'show'

  end

  def history
    if current_customer
      @customer = current_customer
    elsif current_admin && !params[:search].blank? && !params[:search][:customer_id].blank?
      @customer = Customer.find(params[:search][:customer_id])
    end
    @stones = Tender.search_results(params[:search], @customer, true)
    @selling_price = {}

    winners = TenderWinner.where("lot_no in (?) or tender_id in (?)", @stones.collect(&:deec_no), @stones.collect(&:tender_id))

    winners.each do |w|
      @selling_price[w.lot_no.to_s + '_' + w.tender_id.to_s ] = w.selling_price
    end

    respond_to do |format|
      format.html
      format.js {render 'history.js.erb'}
    end
  end

  def trading_history
    @transactions = Transaction.includes(:trading_parcel).where("buyer_id = ? or supplier_id = ?", current_customer.id, current_customer.id)
  end

  def calendar
  end

  def calendar_data
    start_date = Time.at(params[:start].to_i)
    end_date = Time.at(params[:end].to_i)

    @data = current_customer.tenders.tenders_for_calender(start_date, end_date)

    render :json => @data.to_json
  end

  def delete_stones
    @tender = Tender.find(params[:id])
    @tender.stones.destroy_all
    flash[:success] = 'Stones deleted successfully.'
    render :js => "window.location.href = '/admins/tender/#{params[:id]}/edit'"
  end

  def delete_winner_details
    @tender = Tender.find(params[:id])
    @tender.tender_winners.destroy_all
    flash[:success] = 'Winner details deleted successfully.'
    render :js => "window.location.href = '/admins/tender/#{params[:id]}/edit'"
  end

  def confirm_bids
    @message = params[:message] == 'success' ? "Thank You. Successfully Send Confirmation" : "Got Error. Please try later" if params[:message]
    @message = params[:bid_msg] == 'success' ? "Thank You. Bid Updated successfully. Send Confirmation." : "Got Error. Please try later" if params[:bid_msg]
    @tender = Tender.find_by_id(params[:id])
    company = @tender.company
    past_tender = Tender.where("company_id = ? and created_at < ?", company.id, @tender.created_at).last
    @bids = @tender.bids.where(:customer_id => current_customer.id).includes(:stone)
    stones = @bids.map(&:stone)
    @last_avg = {}
    stones.each_with_index do |s, index|
        winners = TenderWinner.where("tender_id =? and description = ?", past_tender.id, s.description)
        if winners
          past_last_avg = (@bids[index].price_per_carat / winners.first.try(:avg_selling_price)) if winners.first
          past_last_avg = past_last_avg.round(2) if past_last_avg
          @last_avg[s.id] = past_last_avg   if past_last_avg
        end
    end
    puts @last_avg
    respond_to do |format|
      format.html # { render :layout => false}
    end
  end

  def send_confirmation
    if params[:tender_id]

      @customer_tender = CustomersTender.where(tender_id: params[:tender_id], customer_id: current_customer.id).first
      @customer_tender.confirmed = true
      @customer_tender.save!
      @bid = Bid.where(tender_id: @customer_tender.tender_id, customer_id: current_customer.id)
      TenderMailer.confirmation_mail(@customer_tender.tender, current_customer, @bid).deliver rescue logger.info "Error sending email"
      @message = "success"
    else
      @bid = Bid.find_or_initialize_by(id: params[:bid_id], customer_id: current_customer.id)
      @tender = @bid.tender
      @bid.total = params[:bid_total]
      @bid.price_per_carat = params[:bid_carat]
      if @bid.save
        @message = "success"
      else
        @message = "error"
      end
    end
    respond_to do |format|
      format.html { render :json => {:bid => @bid, :message => @message }}
    end
  end

  def undo_confirmation
    @customer_tender = CustomersTender.where(tender_id: params[:id], customer_id: current_customer.id)
    @customer_tender.update_attribute(:confirmed, false)
    redirect_to tenders_path
  end

  def view_past_result
    # get last 3 tender details
    if params[:stone_count] == "1"
      @winners = []
    else
      @tender = current_customer.tenders.find(params[:id]) rescue Tender.find(params[:id])
      @desc = params[:key]
      tenders = Tender.includes(:tender_winners).where("id != ? and company_id = ? and date(close_date) < ?", @tender.id, @tender.company_id, @tender.open_date.to_date).order("open_date DESC").limit(5)
      # @winners = TenderWinner.includes(:tender).where("tender_id in (?) and tender_winners.description = ?", tenders.collect(&:id), @desc)
      tender_winner_array = TenderWinner.includes(:tender).where(description: @desc, tender_id: tenders.collect(&:id)).order("avg_selling_price desc").group_by { |t| t.tender.close_date.beginning_of_month }
      @winners = []
      tender_winner_array.each_pair do |tender_winner|
        @winners << tender_winner.try(:last).try(:first)
      end
      @winners = @winners.compact.sort_by{|e| e.tender.open_date}.reverse
    end
    render :partial => 'view_past_result'
  end

  def update_stone_desc
    stone = Stone.find(params[:pk])
    stone.description = params[:value]
    stone.save

    render :text => ""
  end

  def update_winner_desc
    winner = TenderWinner.find(params[:pk])
    winner.description = params[:value]
    winner.save

    render :text => ""
  end

  def show_stone
    @stone = Stone.find(params[:id])
    @bids = @stone.bids.order(:updated_at)
    @highest_bid = @bids.order(:total).last
    @bids.order(:total).first.delete if @bids.count > 10
  end

  private

  def get_value(data)
    return ((data.class == Fixnum or data.class == Float)  ? data : (data.class == String ? data : data.nil? ? nil : data.value))
  end

  def tender_params
    params.require(:tender).permit(:name, :description, :open_date, :close_date, :tender_open, :document_file_name, :document_content_type, :document_file_size, :winner_list_file_name, :winner_list_content_type, :winner_list_file_size, :temp_document_file_name, :temp_document_file_type, :temp_document_file_size, :deec_no_field, :lot_no_field, :desc_field, :sheet_no,:no_of_stones_field,:weight_field,:winner_lot_no_field,:reference_id)
  end

  def stone_params
    params.require(:stone).permit(:stone_type, :no_of_stones,:size,:weight,:carat,:tender_id,:deec_no,:lot_no,:description)
  end

end

