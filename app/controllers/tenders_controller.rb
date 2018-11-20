class TendersController < ApplicationController

  protect_from_forgery :except => [:filter, :temp_filter, :add_rating]

  before_action :authenticate_logged_in_user!, :only => [:index, :history, :show, :filter, :view_past_result]
  before_action :authenticate_customer!, :except => [:index, :history, :delete_stones, :delete_sights, :delete_winner_details, :show, :filter, :view_past_result, :admin_details, :admin_winner_details, :update_stone_desc, :update_winner_desc, :winner_list,:bidder_list,:customer_bid_list,:customer_bid_detail ]
  before_action :authenticate_admin!, :only => [:delete_stones, :delete_sights,:delete_winner_details, :admin_details, :admin_winner_details, :update_stone_desc, :update_winner_desc, :winner_list,:bidder_list,:customer_bid_list,:customer_bid_detail]
  before_action :check_role_authorization, only: [:trading_history, :polished_trading_history]

  layout :false, :only => [:admin_details, :admin_winner_details]


  def new
    @tender = Tender.new
  end

  def create
    @supplier = Supplier.find(params[:search_company])
    @tender = @supplier.tenders.new(tender_params)
    if @tender.save
      @stone = @tender.stones.create(stone_type: params[:stone_type], no_of_stones: params[:no_of_stones], size: params[:size], weight: params[:weight], carat: params[:carat], deec_no: params[:deec_no], lot_no: params[:lot_no], description: params[:description], system_price: params[:system_price],lot_permission: params[:lot_permission])
      redirect_to trading_customers_path
    else
      render 'new'
    end
  end

  def block_lot
    stone = Stone.find(params[:id])
    a = params[:lot_permission]
    if( a == "YES")
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
    upcomimg_str = "open_date > '#{Time.current}'"
    if params[:comapany] || params[:tender] || params[:status]
      col_str =  "tenders.name LIKE '%#{params[:tender]}%'"  unless params[:tender].blank?
      col_str += (col_str.blank?) ? "tenders.supplier_id =  #{params[:company]}" : " AND tenders.supplier_id = #{params[:company]}" unless params[:company].blank?
      col_str += (col_str.blank?) ? ((params[:status] == '0') ? ("tenders.close_date < DATE(NOW())") : ("close_date > DATE(NOW())")) : ((params[:status] == '0') ? (" AND tenders.close_date < DATE(NOW())") : (" AND close_date > DATE(NOW())")) unless params[:status].blank?
    end
    if current_customer
      @tenders = current_customer.tenders.active.where(col_str).order("open_date").page params[:page]
      @upcoming_tenders = current_customer.tenders.where(upcomimg_str).where(col_str).order("open_date").page params[:page]
    else
      @tenders = Tender.active.where(col_str).order("open_date").page params[:page]
      @upcoming_tenders = Tender.where(upcomimg_str).where(col_str).order("open_date").page params[:page]
    end
    @news = News.first(10)

    # GetCustomerViaApiJob.perform_later
  end

  def update_chat_id
    current_customer.update(chat_id: params["QBuser_id"].to_s)
    respond_to do |format|
      format.html { render :json => {:status => "200"}}
    end
  end

  def show
    if current_customer
      @tender = Tender.includes(:stones).find(params[:id])
      # @yes_no_buyer_interest = YesNoBuyerInterest.where(tender_id: @tender.id, customer_id: current_customer.id).first
      # @notes = current_customer.notes.where(tender_id: @tender.id).collect(&:key)
      companies = current_customer.suppliers
      #@tender = companies.eager_load(tenders: [:stones]).where("tenders.id=#{params[:id].to_i}").first.try(:tenders).find(params[:id])
      if @tender.open_date < Time.current && Time.current < @tender.close_date
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
      past_tenders = Tender.where("id != ? and supplier_id = ?", @tender.id, @tender.supplier_id).order("open_date DESC").limit(5)
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
    @stones = Tender.stone_list(@tender.stones, params[:id], current_customer)
    @sights =Tender.sight_list(@tender.sights, params[:id], current_customer)
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
    @note.stone_id = params[:stone_id].present? ? params[:stone_id] : nil
    @note.sight_id = params[:sight_id].present? ? params[:sight_id] : nil
    @note.deec_no = params[:deec_no].present? ? params[:deec_no] : nil
    @note.save(validate: false)

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
    @tenders = Tender.where('close_date < ?', Date.current)
    @supplier = Supplier.all
    @mine = SupplierMine.all
    # if current_customer
    #   @customer = current_customer
    # elsif current_admin && !params[:search].blank? && !params[:search][:customer_id].blank?
    #   @customer = Customer.find(params[:search][:customer_id])
    # end
    # @stones = Tender.search_results(params[:search], @customer, true)
    # @selling_price = {}

    # winners = TenderWinner.where("lot_no in (?) or tender_id in (?)", @stones.collect(&:deec_no), @stones.collect(&:tender_id))

    # winners.each do |w|
    #   @selling_price[w.lot_no.to_s + '_' + w.tender_id.to_s ] = w.selling_price
    # end
    if params[:search].present?
      @tender_winners = TenderWinner.search_results(params[:search], @customer, true).page(params[:page]).per(100)
    else
      @tender_winners = TenderWinner.all.page(params[:page]).per(100)
    end
    respond_to do |format|
      format.html
      format.js {render 'history.js.erb'}
    end
  end

  def trading_history
    @pending_transaction = Transaction.includes(:trading_parcel).where("diamond_type = ? OR diamond_type = ? OR diamond_type = ? OR diamond_type is null", 'Outside Goods', 'Rough', 'Sight').where('(buyer_id = ? or seller_id = ?) and due_date > ? and paid = ?',current_company.id, current_company.id, Date.current, false)
    @overdue_transaction = Transaction.includes(:trading_parcel).where("diamond_type = ? OR diamond_type = ? OR diamond_type = ? OR diamond_type is null", 'Outside Goods', 'Rough', 'Sight').where('(buyer_id = ? or seller_id = ?) and due_date < ? and paid = ?',current_company.id, current_company.id, Date.current, false)
    @completed_transaction = Transaction.includes(:trading_parcel).where("diamond_type = ? OR diamond_type = ? OR diamond_type = ? OR diamond_type is null", 'Outside Goods', 'Rough', 'Sight').where('(buyer_id = ? or seller_id = ?) and paid = ?',current_company.id, current_company.id, true)
  end

  def polished_trading_history
    @polished_pending_transactions = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and due_date > ? and paid = ? and diamond_type = ?',current_company.id, current_company.id, Date.current, false, 'Polished')
    @polished_overdue_transactions = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and due_date < ? and paid = ? and diamond_type = ?',current_company.id, current_company.id, Date.current, false, 'Polished')
    @polished_completed_transactions = Transaction.includes(:trading_parcel).where('(buyer_id = ? or seller_id = ?) and paid = ? and diamond_type = ?',current_company.id, current_company.id, true, 'Polished')
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

  def delete_sights
    @tender = Tender.find(params[:id])
    @tender.sights.destroy_all
    flash[:success] = 'Sights deleted successfully.'
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
    company = @tender.supplier
    past_tender = Tender.where("supplier_id = ? and created_at < ?", company.id, @tender.created_at).last
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
      # # Temp Removed
      # TenderMailer.confirmation_mail(@customer_tender.tender, current_customer, @bid).deliver rescue logger.info "Error sending email"
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
      tenders = Tender.includes(:tender_winners).where("id != ? and supplier_mine_id = ? and date(close_date) < ?", @tender.id, @tender.supplier_mine_id, @tender.open_date.to_date).order("open_date DESC").limit(5)
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

  def yes_or_no_winners
    data = params
    tender = Tender.where(id: data[:tender_id]).first
    timer_info = tender.tender_timer
    #puts timer_info.inspect
    if data[:interest] == "Yes" && data[:reserved_price].present?
      if data[:stone_id].present?
        @yes_no_buyer_interest = YesNoBuyerInterest.where(tender_id: data[:tender_id], stone_id: data[:stone_id], customer_id: data[:current_customer], interest: true, reserved_price: data[:reserved_price], round: timer_info['current_round']).first_or_create
      elsif data[:sight_id].present?
        @yes_no_buyer_interest = YesNoBuyerInterest.where(tender_id: data[:tender_id], sight_id: data[:sight_id], customer_id: data[:current_customer], interest: true, reserved_price: data[:reserved_price], round: timer_info['current_round']).first_or_create
      end
      render :json => { success: true }
    else
      if data[:stone_id].present?
        @yes_no_buyer_interest = YesNoBuyerInterest.where(tender_id: data[:tender_id], stone_id: data[:stone_id], customer_id: data[:current_customer]).last
        if @yes_no_buyer_interest.present?
          @yes_no_buyer_interest.destroy
        end
      elsif data[:sight_id].present?
        @yes_no_buyer_interest = YesNoBuyerInterest.where(tender_id: data[:tender_id], sight_id: data[:sight_id], customer_id: data[:current_customer]).last
        if @yes_no_buyer_interest.present?
          @yes_no_buyer_interest.destroy
        end
      end
      render :json => { success: true }
    end
  end

  def round_updated
    tender = Tender.where(id: params[:tender_id]).first
    locked = true
    if !tender.nil?
      locked = tender.updated_after_round.nil? ? false : tender.updated_after_round
      render :json => { success: true, updated: locked }
    else
      render :json => { success: true, updated: locked }
    end

  end

  def timer_value
    tender = Tender.where(id: params[:tender_id]).first
    timer_tender = tender.tender_timer
    render :json => { success: true, timer: timer_tender }
  end

  def update_time
    tender = Tender.where(id: params[:tender_id]).first
    puts "!!!!!!!!!!!!!!UPDATE ROUND START: #{params[:round].to_i} Time: #{Time.current} - timestamp: #{Time.current.to_i} Customer: #{current_customer.id} email: #{current_customer.email}"
    if !tender.nil?
      if !tender.updated_after_round
        tender.update_columns(updated_after_round: true, round: params[:round].to_i + 1)
        if tender.check_if_bid_placed(params[:round].to_i)
          tender.check_for_winners(params[:round].to_i, current_customer)
        end
        if tender.need_to_update_time?
          round_open_time = tender.round_open_time + (tender.round_duration).minutes + (tender.rounds_between_duration).minutes
          tender.update_column(:round_open_time, round_open_time)
        end
        puts "!!!!!!!!!!!!!!UPDATE ROUND END: with price"
        render :json => { success: true, updated: 'done' }
      else
        puts "!!!!!!!!!!!!!!UPDATE ROUND END: price already updated"
        render :json => { success: true, updated: 'already' }
      end
    end
    puts "!!!!!!!!!!!!!!UPDATE ROUND END: no TENDER"
  end

  def update_system_price
    tender = Tender.where(id: params[:tender_id]).first
    # if !tender.nil? && tender.check_if_bid_placed?
    #   tender.check_for_winners(tender.round, current_customer)
    #   if tender.updated_after_round
    #   else
    #     tender.update_columns(updated_after_round: true, round: tender.round + 1)
    #     if tender.need_to_update_time?
    #       round_open_time = tender.round_open_time + (tender.round_duration).minutes + (tender.rounds_between_duration).minutes
    #       tender.update_column(:round_open_time, round_open_time)
    #     end
    #   end
    # end
    if tender.updated_after_round
      tender.update_column(:updated_after_round, false)
      render :json => { success: true, updated: 'done'}
    else
      render :json => { success: true, updated: 'already' }
    end



    # if @tender.diamond_type == 'Rough'
    #   @tender.stones.each_with_index do |stone,index|
    #     customer_yes_no_bid = stone.yes_no_buyer_interests.where(customer_id: current_customer.id).first
    #     if stone.present? && stone.yes_no_buyer_interests.where(buyer_left: false).length > 1
    #       total_customers = @tender.customers.length
    #       puts "total = #{total_customers}"
    #       system_price,system_price_percentage = 0.0
    #       remaining_customers = stone.yes_no_buyer_interests.where(buyer_left: false).length
    #       puts "Remaining = #{remaining_customers}"
    #       left_customers = total_customers - remaining_customers
    #       puts "LEft = #{left_customers}"
    #       # reserved_price = stone.yes_no_system_price.present? ? stone.yes_no_system_price : stone.reserved_price - ((20.to_f/100.to_f)*stone.reserved_price)
    #       reserved_price = customer_yes_no_bid.reserved_price
    #       puts "reserve price = #{reserved_price}"
    #       if reserved_price.to_f < stone.reserved_price.to_f
    #         system_percentage = (remaining_customers.to_f/3.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f).abs
    #         if system_percentage < 2
    #           system_price_percentage = 2
    #         else
    #           system_price_percentage = system_percentage
    #         end
    #         puts "system_percentage = #{system_percentage}"
    #         puts "system_price_percentage = #{system_price_percentage}"
    #         @yes_no_system_price = ( 100 + system_price_percentage.to_f)/100.to_f*reserved_price.to_f
    #         puts "new price = #{@yes_no_system_price}"
    #       else
    #         system_percentage = (remaining_customers.to_f/5.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f).abs
    #         if system_percentage < 2
    #           system_price_percentage = 2
    #         else
    #           system_price_percentage = system_percentage
    #         end
    #         @yes_no_system_price = ( 100 + system_price_percentage.to_f)/100.to_f*reserved_price.to_f
    #       end
    #       stone.update_attributes(yes_no_system_price: @yes_no_system_price)
    #       customer_yes_no_bid.update_attributes(reserved_price: @yes_no_system_price)
    #     elsif stone.present? && stone.yes_no_buyer_interests.where(buyer_left: false).length == 1
    #       winning_price = stone.yes_no_system_price.present? ? stone.yes_no_system_price : stone.reserved_price - ((20.to_f/100.to_f)*stone.reserved_price)
    #       stone.update_attributes(stone_winning_price: winning_price)
    #       if !stone.yes_no_buyer_winner.present?
    #         winner = stone.yes_no_buyer_interests.where(buyer_left: false)
    #         winner = YesNoBuyerWinner.find_or_initialize_by(yes_no_buyer_interest_id: winner.first.id, tender_id: winner.first.tender_id, stone_id: winner.first.stone_id, sight_id: winner.first.sight_id, customer_id: winner.first.customer_id, bid_open_time: winner.first.bid_open_time, round: winner.first.round-1, winning_price: stone.stone_winning_price, bid_close_time: winner.first.bid_close_time)
    #         winner.save
    #         winner_table = Winner.find_or_initialize_by(tender_id: winner.tender_id,customer_id:winner.customer_id,stone_id: winner.stone_id)
    #         puts winner_table.inspect
    #         puts "00000000000000000000000000000000"
    #         winner_table.save(validate: false)
    #       end
    #     end
    #   end
    # elsif @tender.diamond_type == 'Sight'
    #   @tender.sights.each_with_index do |sight,index|
    #     customer_yes_no_bid = stone.yes_no_buyer_interests.where(customer_id: current_customer.id).first
    #     if sight.present? && sight.yes_no_buyer_interests.where(buyer_left: false).length > 1
    #       total_customers = @tender.customers.length
    #       puts "total = #{total_customers}"
    #       system_price,system_price_percentage = 0.0
    #       remaining_customers = sight.yes_no_buyer_interests.where(buyer_left: false).length
    #       puts "Remaining = #{remaining_customers}"
    #       left_customers = total_customers - remaining_customers
    #       puts "LEft = #{left_customers}"
    #       # reserved_price = sight.yes_no_system_price.present? ? sight.yes_no_system_price : sight.sight_reserved_price.to_f - ((20.to_f/100.to_f)*sight.sight_reserved_price.to_f)
    #       reserved_price = customer_yes_no_bid.reserved_price
    #       puts "reserve price = #{reserved_price}"
    #       if reserved_price.to_f < sight.sight_reserved_price.to_f
    #         system_percentage = (remaining_customers.to_f/3.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f).abs
    #         if system_percentage < 2
    #           system_price_percentage = 2
    #         else
    #           system_price_percentage = system_percentage
    #         end
    #         @yes_no_system_price = ( 100 + system_price_percentage.to_f)/100.to_f*reserved_price.to_f
    #         puts "system_percentage = #{system_percentage}"
    #         puts "system_price_percentage = #{system_price_percentage}"
    #         puts "new price = #{@yes_no_system_price}"
    #       else
    #         system_percentage = (remaining_customers.to_f/5.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f).abs
    #         if system_percentage < 2
    #           system_price_percentage = 2
    #         else
    #           system_price_percentage = system_percentage
    #         end
    #         @yes_no_system_price = ( 100 + system_price_percentage.to_f)/100.to_f*reserved_price.to_f
    #         # system_price = system_price_percentage.to_f/100.to_f*reserved_price.to_f
    #         # @yes_no_system_price = reserved_price.to_f+system_price_percentage.to_f
    #       end
    #       sight.update_attributes(yes_no_system_price: @yes_no_system_price)
    #       customer_yes_no_bid.update_attributes(reserved_price: @yes_no_system_price)
    #     elsif sight.present? && sight.yes_no_buyer_interests.where(buyer_left: false).length == 1
    #       winning_price = sight.yes_no_system_price.present? ? sight.yes_no_system_price : sight.sight_reserved_price.to_f - ((20.to_f/100.to_f)*sight.sight_reserved_price.to_f)
    #       sight.update_attributes(stone_winning_price: winning_price)
    #       if !sight.yes_no_buyer_winner.present?
    #         puts "jjjjjjjjjjjjjjjjjjjjjjjjjjjj"
    #         winner = sight.yes_no_buyer_interests.where(buyer_left: false)
    #         winner = YesNoBuyerWinner.find_or_initialize_by(yes_no_buyer_interest_id: winner.first.id, tender_id: winner.first.tender_id, sight_id: winner.first.sight_id, sight_id: winner.first.sight_id, customer_id: winner.first.customer_id, bid_open_time: winner.first.bid_open_time, round: winner.first.round-1, winning_price: sight.stone_winning_price, bid_close_time: winner.first.bid_close_time)
    #         winner.save
    #         winner_table = Winner.find_or_initialize_by(tender_id: winner.tender_id,customer_id:winner.customer_id,sight_id: winner.sight_id)
    #         puts winner_table.inspect
    #         puts "00000000000000000000000000000000"
    #         winner_table.save(validate: false)
    #       end
    #     end
    #   end
    # end
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
