class WinnersController < ApplicationController

  before_action :authenticate_admin!, :except => [:winner, :print]
  before_action :authenticate_logged_in_user!, :only => [:winner, :print]

  def approved_list
    @tender = Tender.find(params[:tender_id])
    @customers = @tender.customers.order('first_name ASC, last_name ASC')
    @bidders = Bid.find_all_by_tender_id(@tender.id).collect(&:customer_id).uniq
  end
  
  def download_excel
    @tender = Tender.find(params[:tender_id], :include => {:stones => [:bids, :winner]})

    # basic setup
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => @tender.name

    format = Spreadsheet::Format.new :horizontal_align => :left,
    :size => 10

    sheet.default_format = format

    highlight_format = Spreadsheet::Format.new  :pattern_fg_color => :yellow,
    :pattern => 1,
    :border => :thin,
    # :horizontal_align => :centre,
    :weight => :bold,
    :size => 12

    header_format = Spreadsheet::Format.new :horizontal_align => :centre,
    :weight => :bold,
    :size => 15

    sheet[1,2] = @tender.name
    sheet.row(1).default_format = header_format
    sheet.row(1).height = 20
    sheet.row(3).height = 20

    # stone details
    stones = @tender.stones
    stone_length = stones.length

    past_tenders = Tender.find(:all, :conditions => ["id != ? and company_id = ? and date(open_date) < ?",@tender.id, @tender.company_id, @tender.open_date.to_date], :limit => 5, :order => "open_date DESC")
    past_tender = past_tenders.first

    winners = TenderWinner.find_all_by_tender_id(past_tender.id) rescue []
    @winner_list = {}
    winners.each do |w|
      @winner_list[w.lot_no] = w.selling_price
    end

    sheet[3,0] = 'Lot No'
    sheet[3,1] = 'DEEC No'
    sheet[3,2] = 'Description'
    sheet[3,3] = 'No of Stones'
    sheet[3,4] = 'Weight'
    sheet[3,6] = 'Last Results'
    sheet[3,7] = '% Difference'
    sheet.row(3).default_format = highlight_format
    sheet.row(3).height = 15

    c = 4

    total_weight = 0
    stones.each do |s|

      sheet[c, 0] = s.lot_no
      sheet[c, 1] = s.deec_no
      sheet[c, 2] = s.description
      sheet[c, 3] = s.no_of_stones
      sheet[c, 4] = s.weight
      total_weight = total_weight + s.weight.to_f
      sheet[c, 6] = view_context.number_to_currency(@winner_list[s.deec_no])

      sheet.row(c).height = 15

      c = c + 1

    end
    # total weight
    sheet[(c + 1),4] =  total_weight.round(2)

    #bid details

    bids = @tender.bids

    bid_details = {}
    bids.each do |b|
    bid_details[b.customer_id] ||= {}
      bid_details[b.customer_id][b.stone_id] = [b.price_per_carat, b.total]
    end

    #adding customers
    customers =  Customer.find(:all,:conditions => ["id in (?)",bids.pluck(:customer_id).uniq])

    cs = 9

    customers.each do |cus|

      sheet[3,cs] = cus.name

      c = 4
      cus_avg = 0
      cus_total = 0
      stones.each do |s|
        unless bid_details[cus.id][s.id].nil?
          sheet[c, cs] = view_context.number_to_currency( bid_details[cus.id][s.id][0] ) + " / " + view_context.number_to_currency( bid_details[cus.id][s.id][1] )
        cus_avg = cus_avg + bid_details[cus.id][s.id][0]
        cus_total = cus_total + bid_details[cus.id][s.id][1]
        end
        c = c + 1
      end
      sheet[(c + 1), cs] = view_context.number_to_currency( cus_avg ) + " / " + view_context.number_to_currency( cus_total )
      cs = cs + 1

    end

    #total row format
    sheet.row(c+1).default_format = highlight_format
    sheet.row(c+1).height = 15

    sheet[3,cs + 1] = 'Highrest Bidder (Avg)'
    sheet[3,cs + 2] = 'Final Price (Total bid)'
    #  sheet[3,cs + 3] = 'Price with Decimals'

    c = 4
    highest_bidder_avg = 0
    highest_bidder_total = 0
    stones.each do |s|
      sheet[c, 7] = ( s.top_bid.first.price_per_carat.to_f / @winner_list[s.deec_no] ).round(2) unless (s.top_bid.blank? or @winner_list[s.deec_no].nil?)

      sheet[c, cs + 1] = view_context.number_to_currency( s.top_bid.first.price_per_carat.to_f ) unless s.top_bid.blank?
      highest_bidder_avg = highest_bidder_avg + s.top_bid.first.price_per_carat.to_f unless s.top_bid.blank?

      sheet[c, cs + 2] = view_context.number_to_currency( s.top_bid.first.total.to_f ) unless s.top_bid.blank?
      highest_bidder_total = highest_bidder_total + s.top_bid.first.total.to_f unless s.top_bid.blank?
      #   sheet[c, cs + 3] = s.winner.bid.total unless s.winner.blank?
      c = c + 1
    end
    sheet[(c + 1), cs + 1] = view_context.number_to_currency( highest_bidder_avg ) unless highest_bidder_avg == 0
    sheet[(c + 1), cs + 2] = view_context.number_to_currency( highest_bidder_total )  unless highest_bidder_total == 0

    #setting width
    (0..1).each do |i|
      sheet.column(i).width = 15
    end
    sheet.column(2).width = 35
    sheet.column(3).width = 20
    (6..(cs+3)).each do |i|
      sheet.column(i).width = 25
    end

    book.write Rails.root + "public/#{@tender.name.parameterize}.xls"
    send_file Rails.root + "public/#{@tender.name.parameterize}.xls"

  # render :text => @winner_list

  end

  def list
    @tenders = Tender.order("created_at desc")
  end

  def bidders
    @tender = Tender.find(params[:tender_id])
    @stones = @tender.stones

    respond_to do |format|

      format.xls{

        filename = "Bidders List - #{@tender.name} #{@tender.open_date.strftime('%B')} #{@tender.open_date.year}.xls"
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""

      }

      format.html

    end

  end

  def winner

    if current_admin
      @tender = Tender.find(params[:tender_id])
    elsif current_customer
      @tender = current_customer.tenders.find(params[:tender_id])
    end

    @stones = @tender.stones

    winners = TenderWinner.find_all_by_tender_id(@tender.id)

    @winner_list = {}
    winners.each do |w|
      @winner_list[w.lot_no] = w.selling_price
    end

    respond_to do |format|

      format.xls{

        filename = "Winners List - #{@tender.name} #{@tender.open_date.strftime('%B')} #{@tender.open_date.year}.xls"
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""

      }

      format.html

    end

  end

  def results
    @tender = Tender.find_by_id(params[:tender])
    company = @tender.company
    @tenders = company.tenders.where("created_at < ?", @tender.created_at).order("created_at desc").limit(2)    
    twinner1 = @tenders.last.tender_winners if @tenders.any?
    twinner2 = @tenders.first.tender_winners if @tenders.any?
    @tender_stones = @tender.stones
    if params[:sort_by_average]
      @winners = @tender.sort_by_avg(@tender, @tenders.first) 
    else
      @winners = @tender.tender_winners
    end   
    @stones1 = {}
    @stones2 = {}
    @stones = {}
    if @winners.any?
    @winners.try(:each_with_index) do |w, i|
      stone = Stone.where(:description => w.description, :tender_id => @tender.id )      
      if stone.count == 1
        @stones[w.id] =  stone.try(:first).try(:weight)
        if (@tenders && @tenders.any?)
          ts1 = TenderWinner.where(:description => w.description, :tender_id => @tenders.first.id ) if @tenders.try(:first)
          @stones1[w.id] = ts1.first.try(:avg_selling_price) if ts1.any?
          ts2 = TenderWinner.where(:description => w.description, :tender_id => @tenders.last.id ) if @tenders.count == 2 && @tenders.try(:last)
          @stones2[w.id] = ts2.first.try(:avg_selling_price) if ts2 && ts2.any?
          @stones2[w.lot_no] = "red_text"  if (@stones1[w.id] && @stones2[w.id] && (@stones1[w.id].to_f.between?(@stones2[w.id].to_f, w.avg_selling_price.to_f)))
          @stones1[w.lot_no] = "red_text"  if (@stones1[w.id] && @stones2[w.id] && @stones1[w.id] < @stones2[w.id].to_f)
          @stones[w.lot_no] = "main_red_text"  if (@stones1[w.id] && w.avg_selling_price &&  (w.avg_selling_price.to_f < @stones1[w.id].to_f) ) 
        end  
      else
        stone_dec = stone.try(:first).try(:description)
        stone_dec = stone_dec.gsub!(/\W+/, '') if stone_dec
        if instance_variable_defined?("@stone_dec") 
          instance_variable_set("@total#{stone_dec}",  stone.count)
          completed = instance_variable_defined?("@completed#{stone_dec}")  ?  instance_variable_get("@completed#{stone_dec}")  : 1  
          instance_variable_set("@completed#{stone_dec}", completed)
          if instance_variable_get("@total#{stone_dec}") != instance_variable_get("@completed#{stone_dec}") 
            deec_no = stone[instance_variable_get("@completed#{stone_dec}")].try(:deec_no)  
            new_stone = Stone.where(:description => w.description, :tender_id => @tender.id, :deec_no => deec_no)
            @stones[w.id] = new_stone.try(:first).try(:weight) if new_stone
            if @tenders
              ts1 = TenderWinner.where(:description => w.description, :tender_id => @tenders.first.id ) if @tenders.try(:first)
              @stones1[w.id] = ts1.first.try(:avg_selling_price) if ts1

              ts2 = TenderWinner.where(:description => w.description, :tender_id => @tenders.last.id ) if @tenders.count == 2 && @tenders.try(:last)
              @stones2[w.id] = ts2.first.try(:avg_selling_price) if ts2
            end 
           
            remaining =  (instance_variable_get("@total#{stone_dec}") - (instance_variable_get("@completed#{stone_dec}") + 1))
            instance_variable_set("@remaining#{stone_dec}", remaining)            
            completed = instance_variable_get("@total#{stone_dec}") - instance_variable_get("@remaining#{stone_dec}")            
            instance_variable_set("@completed#{stone_dec}", completed)                        
          end
        else
          instance_variable_set("@stone_dec",  stone_dec) 
          @stones[w.id] =  stone.try(:first).try(:weight)
          ts1 = TenderWinner.where(:description => w.description, :tender_id => @tenders.try(:first).try(:id) ) if @tenders.try(:first)
          @stones1[w.id] = ts1.first.try(:avg_selling_price) if ts1
          ts2 = TenderWinner.where(:description => w.description, :tender_id => @tenders.try(:last).try(:id) ) if @tenders.count == 2 && @tenders.try(:last)
          @stones2[w.id] = ts2.first.try(:avg_selling_price) if ts2
        end        
      end
     end 
    end  
    respond_to do |format|      
      format.html { render :layout => false}
    end
  end  

  def print

    if current_admin
      @tender = Tender.find(params[:tender_id])
    elsif current_customer
      @tender = current_customer.tenders.find(params[:tender_id])
    end

    @stones = @tender.stones

    winners = TenderWinner.find_all_by_tender_id(@tender.id)

    @winner_list = {}
    winners.each do |w|
      @winner_list[w.lot_no] = w.selling_price
    end

    respond_to do |format|

      format.xls{

        filename = "Winners List - #{@tender.name} #{@tender.open_date.strftime('%B')} #{@tender.open_date.year}.xls"
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""

      }

      format.html

    end

  end

  def save
    @winner_attr = params['winner']
    unless @winner_attr.nil?
      @winner_attr.each do |k, winner_attr|
        unless winner_attr['bid_id'].blank?

          winner = Winner.find_or_initialize_by_tender_id_and_stone_id(winner_attr['tender_id'],winner_attr['stone_id'])
          winner.customer_id = winner_attr['customer_id']
          winner.bid_id = winner_attr['bid_id']
          winner.save

          logger.info winner_attr

        #  Winner.create(winner_attr)
        end
      end
    end
    redirect_to winner_winners_path(:tender_id => params[:tender_id])
  end

end

