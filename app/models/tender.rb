class Tender < ApplicationRecord
  include DocumentUrl
  paginates_per 50

  attr_accessible :name, :description, :open_date, :close_date, :tender_open, :customer_ids, :document, :no_of_stones,
                  :weight, :carat, :tender_type, :size, :purity, :polished, :color, :stones_attributes, :send_confirmation,
                  :delete_stones,:delete_winner_list, :winner_list, :temp_document, :company_id, :deec_no_field, :lot_no_field, :desc_field, :no_of_stones_field, :weight_field, :sheet_no,
                  :winner_lot_no_field, :winner_desc_field, :winner_no_of_stones_field, :winner_weight_field, :winner_selling_price_field, :winner_carat_selling_price_field,:winner_sheet_no, :reference_id, :diamond_type, :bid_open, :round_duration, :rounds_between_duration, :sight_document, :s_no_field, :source_no_field, :box_no_field, :carats_no_field, :cost_no_field, :boxvalue_no_field, :sight_no_field, :sight_reserved_field, :price_no_field, :credit_no_field, :reserved_field,
                  :supplier_mine_id, :country, :city, :timezone, :sights_attributes, :bid_close, :round
  # attr_accessible :name, :description, :open_date, :close_date, :tender_open, :customer_ids, :document, :no_of_stones,
  #                 :weight, :carat, :tender_type, :size, :purity, :polished, :color, :stones_attributes, :send_confirmation,
  #                 :delete_stones,:delete_winner_list, :winner_list, :temp_document, :company_id, :deec_no_field, :lot_no_field, :desc_field, :no_of_stones_field, :weight_field, :sheet_no,
  #                 :winner_lot_no_field, :winner_desc_field, :winner_no_of_stones_field, :winner_weight_field, :winner_selling_price_field, :winner_carat_selling_price_field,:winner_sheet_no, :reference_id,
  #                 :country, :city

  attr_accessor :delete_stones, :delete_winner_list, :total_carat_value


  has_many :customers_tenders
  has_many :customers, :through => :customers_tenders
  has_many :bids, :dependent => :destroy
  has_many :stones, -> { order(:lot_no) }, :dependent => :destroy
  has_many :temp_stones, -> { order(:lot_no) }, :dependent => :destroy
  has_many :winners
  has_many :tender_winners
  has_many :tender_notifications
  belongs_to :company, optional: true
  has_many :reference, :class_name => "Tender", :foreign_key => "reference_id"
  belongs_to :parent_reference, :class_name => "Tender", :foreign_key => "reference_id", optional: true
  has_many :sights
  has_many :yes_no_buyer_winners
  # has_many :tender_notifications
  belongs_to :company, optional: true
  has_many :yes_no_buyer_interests

  accepts_nested_attributes_for :stones
  accepts_nested_attributes_for :sights

  validates_presence_of :name, :open_date, :close_date, :company_id, :round_duration, :rounds_between_duration, :bid_open, :tender_type, :diamond_type

  has_attached_file :temp_document
  do_not_validate_attachment_file_type :temp_document
  has_attached_file :document
  do_not_validate_attachment_file_type :document
  has_attached_file :sight_document
  do_not_validate_attachment_file_type :sight_document
  has_attached_file :winner_list
  do_not_validate_attachment_file_type :winner_list

  after_save :create_stones_from_uploaded_file
  after_save :create_sights_from_uploaded_file
  # after_save :create_temp_stones_from_uploaded_file #==> remove on Nov 15 2013
  after_save :update_winner_list_from_uploaded_file
  after_update :update_round_open_time,  :if => :bid_open_changed?

  after_create_commit :delayed_job_need_to_perform
  after_create :send_tender_create_push, :add_users_to_tender
  after_update :send_tender_update_push

  scope :open_tenders, lambda{|date| where("close_date >= ?", date.beginning_of_day) }

  scope :closed_tenders, lambda{|date| where("close_date < ?", date.end_of_day) }

  scope :active_open_for_dates, lambda{|start_date, end_date|
    where("(open_date >= ? AND open_date <= ?)", start_date.beginning_of_day, end_date.end_of_day)
  }

  scope :active_close_for_dates, lambda{|start_date, end_date|
    where("(close_date <= ? AND close_date >= ?)", end_date.end_of_day, start_date.beginning_of_day)
  }

  scope :opening_today, -> { where("open_date <= ? AND open_date >= ?", DateTime.now.in_time_zone.end_of_day, DateTime.now.in_time_zone.beginning_of_day)}

  scope :closing_today, -> { where("close_date <= ? AND close_date >= ?", DateTime.now.in_time_zone.end_of_day, DateTime.now.in_time_zone.beginning_of_day)}

  scope :active, -> { where("open_date <= ? AND close_date >= ?", Time.zone.now, Time.zone.now) }


  #  validates_attachment_content_type :document, :content_type => ["application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/excel"], :message => 'Only *.xls files allowed'
  def self.tenders_with_bid
    where(:id => Bid.all.map(&:tender_id).uniq)
  end


  def past_details
    tenders = Tender.includes(:stones).where("id != ? and company_id = ? and created_at < ?", self.id, self.company_id, self.created_at).order("close_date DESC").limit(5)

    past_count = {}

    tenders.each do |t|
      t.stones.each do |tw|
        past_count[tw.description] ||= 1
        past_count[tw.description] += 1
      end
    end

    return past_count

  end

  def past_winners
    tenders = Tender.includes(:tender_winners).where("id != ? and company_id = ? and created_at < ?", self.id, self.company_id, self.created_at).order("close_date DESC").limit(5)

    past_count = {}

    tenders.each do |t|
      t.tender_winners.each do |tw|
        past_count[tw.description] ||= 1
        past_count[tw.description] += 1
      end
    end

    return past_count

  end

  def winning_bid
    Bid.where(:id => self.stones.map(&:id)).order('total DESC').first
  end

  def winning_customer
    winning_bid.blank? ? '' : winning_bid.customer.name
  end

  def send_confirmation?
    self.send_confirmation ? 'Yes' : 'No'
  end

  def bid_count(customer = nil)
    unless customer.blank?
      Bid.where(:stone_id => self.stone_ids, :customer_id => customer.id).count
    else
      Bid.find_by_sql("
        SELECT * FROM tenders t
        INNER JOIN customers_tenders ct ON t.id = ct.tender_id
        INNER JOIN customers c ON c.id = ct.customer_id
        INNER JOIN bids b ON (b.customer_id = c.id AND b.tender_id = t.id)
        where ct.confirmed = #{true}
        AND b.tender_id = #{self.id}
      ").count
      #      Bid.joins(:tender => :customers).where(:tender_id => self._id).where('customers_tenders.confirmed = ?', true).uniq.count
      #      Bid.joins(:tender => :customers).where(:stone_id => self.stone_ids).where('customers_tenders.confirmed = ?', true).count
    end
  end

  def sight_bid_count(customer = nil)
    unless customer.blank?
      Bid.where(:sight_id => self.sight_ids, :customer_id => customer.id).count
    else
      Bid.find_by_sql("
        SELECT * FROM tenders t
        INNER JOIN customers_tenders ct ON t.id = ct.tender_id
        INNER JOIN customers c ON c.id = ct.customer_id
        INNER JOIN bids b ON (b.customer_id = c.id AND b.tender_id = t.id)
        where ct.confirmed = #{true}
        AND b.tender_id = #{self.id}
      ").count
    end
  end

  def sort_by_avg(tender1, tender2)
    TenderWinner.find_by_sql("
    select t1.* from tender_winners as t1, tender_winners as t2
    where t1.tender_id = '#{tender1.id}' and t2.tender_id = '#{tender2.id}'
      AND t1.description = t2.description
      group by t1.lot_no
    order by t1.avg_selling_price > t2.avg_selling_price, t1.avg_selling_price
    ")
  end

  def total_bid_amount(customer)
    # self.bids.map(&:total).sum rescue 0
    Bid.where(:stone_id => self.stone_ids, :customer_id => customer.id).map(&:total).sum.round(2) rescue 0
  end

  def total_sight_bid_amount(customer)
    Bid.where(:sight_id => self.sight_ids, :customer_id => customer.id).map(&:total).sum.round(2) rescue 0
  end

  def delayed_job_need_to_perform
    if self.tender_type == "Yes/No"
      Delayed::Job.enqueue YesNoBiddingJob.new(self.id), 0, (self.bid_close)
    end
  end

  def create_stones_from_uploaded_file
    if self.saved_change_to_document_updated_at?
      file_path = document_url(self.document)
      data_file = Spreadsheet.open(open(file_path))
      worksheet = data_file.worksheet(self.sheet_no.to_i - 1)
      unless worksheet.nil?
        worksheet.each_with_index do |data_row, i|
          unless Tender.get_value(data_row[Tender.get_index(self.desc_field)]) == "Description" || Tender.get_value(data_row[Tender.get_index(self.desc_field)]) == "DESCRIPTION"
            unless data_row[('A'..'AZ').to_a.index(self.lot_no_field)].nil?
              stone = self.stones.find_or_initialize_by(lot_no: Tender.get_value(data_row[Tender.get_index(self.lot_no_field)]))
              stone.deec_no = Tender.get_value(data_row[Tender.get_index(self.deec_no_field)]) unless self.deec_no_field.blank?
              stone.description = Tender.get_value(data_row[Tender.get_index(self.desc_field)]) unless self.desc_field.blank?
              stone.no_of_stones = Tender.get_value(data_row[Tender.get_index(self.no_of_stones_field)]) unless self.no_of_stones_field.blank?
              stone.weight = Tender.get_value(data_row[Tender.get_index(self.weight_field)].to_f) unless self.weight_field.blank?
              stone.stone_type = (data_row[Tender.get_index(self.no_of_stones_field)].to_i == 1 ? 'Stone' : 'Parcel' rescue 'Stone'  ) unless self.no_of_stones_field.blank?
              stone.reserved_price = Tender.get_value(data_row[Tender.get_index(self.reserved_field)]) unless self.reserved_field.blank?
              stone.save
              # if stone.save
              #   tender = Tender.find(stone.tender_id)
              #   if tender.tender_type == "Yes/No"
              #     id = tender.id
              #     stone_id = stone.id
              #     customer_id = tender.customers.ids
              #     customer_id.each do |c|
              #       yes_no_buyer_interests = YesNoBuyerInterest.find_or_initialize_by(tender_id: id, stone_id: stone_id, customer_id: c, bid_open_time: tender.bid_open, bid_close_time: tender.bid_close, round: 1)
              #       yes_no_buyer_interests.reserved_price = stone.reserved_price - ((20.to_f/100.to_f)*stone.reserved_price)
              #       yes_no_buyer_interests.save
              #     end
              #   end
              # end
            end
          end
        end
      end
    end
  end

  def create_sights_from_uploaded_file
    if self.sight_document_updated_at_changed?
      # data_file = Spreadsheet.open(self.sight_document.path)
      file_path = document_url(self.sight_document)
      data_file = Spreadsheet.open(open(file_path))
      worksheet = data_file.worksheet(self.sheet_no.to_i - 1)
      unless worksheet.nil?
        worksheet.each_with_index do |data_row, i|
          unless i == 0
            unless data_row[('A'..'AZ').to_a.index(self.source_no_field)].nil?
              sight = self.sights.new
              sight.source = Tender.get_value(data_row[Tender.get_index(self.source_no_field)]) unless self.source_no_field.blank?
              sight.box = Tender.get_value(data_row[Tender.get_index(self.box_no_field)]) unless self.box_no_field.blank?
              sight.carats = Tender.get_value(data_row[Tender.get_index(self.carats_no_field)]) unless self.carats_no_field.blank?
              sight.cost = Tender.get_value(data_row[Tender.get_index(self.cost_no_field)]) unless self.cost_no_field.blank?
              box_value = Tender.get_value(data_row[Tender.get_index(self.boxvalue_no_field)]) unless self.boxvalue_no_field.blank?
              sight.box_value_from = box_value.present? ? box_value.to_s.split("-").first : 0
              sight.box_value_to = box_value.present? ? box_value.to_s.split("-").last : 0
              sight.sight = data_row[Tender.get_index(self.sight_no_field)] unless self.sight_no_field.blank?
              sight.price = Tender.get_value(data_row[Tender.get_index(self.price_no_field)]) unless self.price_no_field.blank?
              sight.credit = Tender.get_value(data_row[Tender.get_index(self.credit_no_field)]) unless self.credit_no_field.blank?
              sight.sight_reserved_price = Tender.get_value(data_row[Tender.get_index(self.sight_reserved_field)]) unless self.sight_reserved_field.blank?
              sight.save
              # if sight.save
              #   puts "#{sight.inspect}"
              #   tender = Tender.find(sight.tender_id)
              #   if tender.tender_type == "Yes/No"
              #     id = tender.id
              #     sight_id = sight.id
              #     customer_id = tender.customers.ids
              #     customer_id.each do |c|
              #       yes_no_buyer_interests = YesNoBuyerInterest.find_or_initialize_by(tender_id: id, sight_id: sight_id, customer_id: c, bid_open_time: tender.bid_open, bid_close_time: tender.bid_close, round: 1)
              #       yes_no_buyer_interests.reserved_price = sight.sight_reserved_price - ((20.to_f/100.to_f)*sight.sight_reserved_price)
              #       puts yes_no_buyer_interests.inspect
              #       yes_no_buyer_interests.save
              #     end
              #   end
              # end
            end
          end
        end
      end
    end
  end

  before_save do
    if !self.round_duration.nil?
      bid_close = self.bid_open+(self.round_duration*60)
      self.bid_close = bid_close
    end
  end

  def Tender.get_index(alpha)
    ary = ('A'..'AZ').to_a
    puts "===========#{alpha}================"
    puts "===========#{ary.index(alpha)}================"

    return ary.index(alpha)

  end

  # def create_temp_stones_from_uploaded_file
  # if self.temp_document_updated_at_changed?
  # data_file = Spreadsheet.open(self.temp_document.path)
  # worksheet = data_file.worksheet(0)
  # worksheet.each_with_index do |data_row, i|
  # unless i == 0
  # unless data_row[0].nil?
  # (
  # stone = self.temp_stones.build(
  # :lot_no => Tender.get_value(data_row[0]),
  # :description => Tender.get_value(data_row[1]),
  # :no_of_stones => Tender.get_value(data_row[8]),
  # :carat => Tender.get_value(data_row[9]),
  # )
  # stone.save
  # puts stone.errors.inspect
  # )
  # end
  # end
  # end
  #
  # end
  # end

  #Determines if tender is open or not
  def open?
    self.close_date > DateTime.now rescue false
  end

  def update_winner_list_from_uploaded_file
    if self.winner_list_updated_at_changed?
      puts "==============file==============="
      unless self.winner_list.nil?
        file_path = document_url(self.winner_list)
        data_file = Spreadsheet.open(open(file_path))
        worksheet = data_file.worksheet(self.winner_sheet_no.to_i - 1)
        unless worksheet.nil?
          worksheet.each_with_index do |data_row, i|
            unless data_row[Tender.get_index(self.winner_lot_no_field)].nil?
              lot_no = Tender.get_value(data_row[Tender.get_index(self.winner_lot_no_field)])
              win = TenderWinner.where(tender_id: self.id, lot_no: lot_no).first_or_initialize
              win.description = data_row[Tender.get_index(self.winner_desc_field)]
              win.selling_price = Tender.get_value(data_row[Tender.get_index(self.winner_selling_price_field)])
              # actual_selling_price = Tender.get_value(data_row[Tender.get_index(self.winner_selling_price_field)])
              # check_selling_price(actual_selling_price)
              win.avg_selling_price = Tender.get_value(data_row[Tender.get_index(self.winner_carat_selling_price_field)])
              win.save(validate: false)
              puts win.errors.inspect
            end
          end
          # Temprory stop
          # Tender.send_winner_list_uploaded_mail(self.id)
        end
      end

    else
      puts "==============no file==============="
    end
  end

  # def check_selling_price(actual_selling_price)
  #   @stones = self.stones
  #   @stones.each do |stone|
  #     selling_price = stone.winner.try(:bid).try(:total)
  #     customer = stone.winner.try(:bid).try(:customer)
  #     TenderMailer.send_notify_winning_buyers_mail(self, customer).deliver rescue logger.info "Error sending email" if (actual_selling_price == selling_price && customer)
  #   end
  # end

  def Tender.send_winner_list_uploaded_mail(id)
    tender = Tender.find(id)
    tender.customers.each do |c|
      # TenderMailer.send_winner_list_uploaded_mail(tender, c).deliver rescue logger.info "Error sending email"
    end
  end

  def customer_bid_amount(customer)
    self.bids.find_by_customer_id(customer.id).total
  end

  def customer_bid_amount(customer)
    self.bids.find_by_customer_id(customer.id).total
  end

  def past_tenders
  end

  def tender_bids
    cust_arr = []
    self.customers.each do |c|
      bids = c.bids.where(:tender_id => self.id)
      cust_arr << bids
    end
    cust_arr = cust_arr.any?  ? cust_arr.flatten : []
  end

  def total_bids_amount
    #self.bids.pluck(:total).inject{|sum,x| sum + x}.round(2)
    self.bids.map(&:total).inject{|sum,x| sum + x}.round(2)
  end

  def tender_successful_bids
    bids = Bid.find_by_sql("
      select * from  bids where id in
      (select t.value from (select max(price_per_carat), id as value
        from bids where tender_id = '#{self.id}'
        and price_per_carat != 0 group by stone_id) t)
     ")
    # winners = self.tender_winners
    # winner_list = {}
    # winners.each do |w|
    #   winner_list[w.lot_no] = w.selling_price
    # end
    # bids=[]
    # stones = self.stones.includes(:winner => :bid)
    # stones.each do |stone|
    #   winner = stone.winner
    #   if (winner)# && (winner_list[stone.deec_no].to_i == winner.bid.total.to_i ))
    #     bids << winner.bid unless winner.bid.total.to_f == 0.0
    #    end
    # end
    bids
  end

  def successful_bids_amount
    sum = 0
    if self.tender_successful_bids.any?
      sum = self.tender_successful_bids.any?  ? self.tender_successful_bids.map(&:total).inject{|sum, x| sum + x}.round(2) : 0
    end
    sum
  end

  def unsuccessful_bids_amount
   (total_bids_amount.to_f - successful_bids_amount.to_f).round(2)
  end

  def last_winner(stone_desc, past_tender_id)
    history = TenderWinner.where("tender_id in (?) and description = ?", past_tender_id, stone_desc).order("tender_id")
    history.any? ? history.last.avg_selling_price : 0
  end

  def Average_last_winner(bit_per_carat, last_winner)
    return 0 if last_winner == 0
    per_diff = (100 - (bit_per_carat / last_winner * 100)).round(2)
    act_diff = per_diff > 0 ? "-" : "+"
    act_diff <<   per_diff.abs.to_s
  end

  def remaining_time_in_secs
    if self.bid_open.present? and self.bid_close.present?
      if Time.current.between?(self.bid_open, self.bid_close)
        self.bid_close.to_i - Time.current.to_i
      end
    end
  end

  def self.stone_list(stones, id, current_customer)
    read_tick_stones =[]
    read_stones=[]
    tick_stones=[]
    rest_stones=[]
    tender_stones=[]
    stones.each_with_index do |stone,i|
      key="#{stone.description}##{stone.weight}"
      read = Rating.where(key: key, flag_type: 'Read', tender_id: id, customer_id: current_customer.id)
      tick = Rating.where(key: key,flag_type: 'Imp', tender_id: id, customer_id: current_customer.id)
      if tick.present? && read.present?
        read_tick_stones << stone
      elsif read.present?
        read_stones << stone
      elsif tick.present?
        tick_stones << stone
      else
        rest_stones << stone
      end
    end
    tender_stones << read_tick_stones
    tender_stones << read_stones
    tender_stones << tick_stones
    tender_stones << rest_stones
    tender_stones = tender_stones.flatten
    return tender_stones
  end

  def self.sight_list(sights, id, current_customer)
    read_tick_sights =[]
    read_sights=[]
    tick_sights=[]
    rest_sights=[]
    tender_sights=[]
    sights.each_with_index do |sight,i|
      key="#{sight.source}##{sight.carats}"
      read = Rating.where(key: key, flag_type: 'Read', tender_id: id, customer_id: current_customer.id)
      tick = Rating.where(key: key,flag_type: 'Imp', tender_id: id, customer_id: current_customer.id)
      if tick.present? && read.present?
        read_tick_sights << sight
      elsif read.present?
        read_sights << sight
      elsif tick.present?
        tick_sights << sight
      else
        rest_sights << sight
      end
    end
    tender_sights << read_tick_sights
    tender_sights << read_sights
    tender_sights << tick_sights
    tender_sights << rest_sights
    tender_sights = tender_sights.flatten
    return tender_sights
  end

  def self.tenders_for_calender(start_date, end_date)
    @open_data = Tender.active_open_for_dates(start_date, end_date)
    @close_data = Tender.active_close_for_dates(start_date, end_date)

    @hash = []

    @open_data.each do |d|
      op = {}
      op['id'] = d.id
      op['title'] = d.name
      op['color'] = 'green'
      op['url'] = ''
      op['allDay'] = false
      op['start'] =  d.open_date.to_datetime
      #op['end'] =  d.open_date.to_datetime
      @hash << op
    end

    @close_data.each do |d|
      op = {}
      op['id'] = d.id
      op['title'] = d.name
      op['color'] = 'red'
      op['url'] = ''
      op['allDay'] = false
      op['start'] = d.close_date.to_datetime
      #     op['end'] = d.close_date.to_datetime
      @hash << op
    end

    @hash
  end

  # # Pewviously used in history page search
  # def self.search_results(filters, current_customer, history_page = false)
  #   query = []
  #   unless filters.blank?
  #     query << "tenders.id in (#{Array(filters[:name]).join(',')})" unless filters[:name].blank?
  #     query << "tenders.company_id in (#{Array(filters[:supplier_name]).join(',')})" unless filters[:supplier_name].blank?
  #     query << "tenders.supplier_mine_id in (#{Array(filters[:mine_name]).join(',')})" unless filters[:mine_name].blank?
  #     query << "tenders.open_date >= '#{filters[:start_date].to_datetime.beginning_of_day}'" unless filters[:start_date].blank?
  #     query << "tenders.close_date <= '#{filters[:end_date].to_datetime.end_of_month}'" unless filters[:end_date].blank?
  #     query << "(tenders.open_date <= '#{filters[:specific_date].to_datetime.beginning_of_day}' AND tenders.open_date >= '#{filters[:specific_date].to_datetime.beginning_of_day}') OR (close_date <= '#{filters[:specific_date].to_datetime.end_of_month}' AND close_date >= '#{filters[:specific_date].to_datetime.end_of_month}')" unless filters[:specific_date].blank?
  #     query << "stones.stone_type like '%#{filters[:type]}%'" unless filters[:type].blank?
  #     query << "stones.description like '%#{filters[:description]}%'" unless filters[:description].blank?
  #     query << "stones.weight like '%#{filters[:size]}%'" unless filters[:size].blank?
  #     query << "stones.carat = '#{filters[:carat]}'" unless filters[:carat].blank?
  #     query << "stones.color = '#{filters[:color]}'" unless filters[:color].blank?
  #     query << "stones.purity = '#{filters[:purity]}'" unless filters[:purity].blank?
  #   end
  #   query = query.join(' AND ')
  #   if history_page
  #     if current_customer
  #       Stone.joins(:tender, :bids => :customer).where("customer_id = #{current_customer.id}").where(query)
  #     else
  #       Stone.joins(:tender, :bids => :customer).where(query)
  #     end
  #   else
  #     if current_customer.blank?
  #       Tender.joins(:stones).where(query)
  #     else
  #       current_customer.tenders.joins(:stones).where(query)
  #     end
  #   end
  # end

  def self.send_open_notification
    @tenders = Tender.opening_today
    @tenders.each do |tender|
      unless tender.created_at.beginning_of_day <= tender.open_date && tender.open_date <= tender.created_at.end_of_day
        tender.customers.each do |customer|
          # TenderMailer.send_tender_open_notification(tender, customer).deliver rescue logger.info "Error sending email"
        end
      end
    end
  end

  def self.send_close_notification
    @tenders = Tender.closing_today
    @tenders.each do |tender|
      Admin.all.each do |admin|
        # TenderMailer.send_tender_close_notification(tender, admin).deliver rescue logger.info "Error sending email"
      end
      tender.customers.each do |customer|
        # TenderMailer.send_tender_close_notification(tender, customer).deliver rescue logger.info "Error sending email"
      end
    end

    save_winners
  end

  def self.save_winners
    @tenders = Tender.closing_today
    @tenders.each do |tender|
      tender.stones.each do |stone|
        unless stone.bids.blank?
          winning_bid = stone.top_bid.first
          winner = Winner.find_or_initialize_by(tender_id: tender.id, stone_id: stone.id)
          winner.bid_id = winning_bid.id
          winner.customer_id = winning_bid.customer.id
          winner.save
        end
      end
    end
  end

  def self.get_value(data)
    return ((data.class == Fixnum or data.class == Float)  ? data : (data.class == String ? data : data.nil? ? nil : data.value))
  end

  def winner_details
    self.id
  end

  def Tender.total_winner_value(id)
    sum = 0.0
    tender = Tender.find(id)
    if tender.tender_winners.length == 0
      return "-"
    else
      tender.tender_winners.each do |s|
        sum = sum + s.selling_price.to_f
      end
      return sum.round(2)
    end
  end

  def Tender.total_carat_value(id)
    sum = 0.0
    tender = Tender.find(id)
    if tender.stones.present?
      tender.stones.each do |s|
        sum = sum + s.weight.round(2) rescue 0.0
      end
      return sum.round(2)
    elsif tender.sights.present?
      tender.sights.each do |s|
        sum = sum + s.carats.round(2) rescue 0.0
      end
      return sum.round(2)
    end
  end

  def check_notification(customer)
    tender = TenderNotification.where(customer_id: customer.id, tender_id: self.id, notify: true).first
    if tender.nil?
      false
    else
      true
    end
  end

  def send_tender_create_push
    message = "New Tender Alert: #{self.company.try(:name)}: #{self.name}: #{self.open_date.try(:strftime, "%b,%d")} - #{self.close_date.try(:strftime, "%b,%d")}"
    # Cusetomers
    customers_to_notify = SupplierNotification.where(supplier_id: self.company_id, notify: true).map { |e| e.customer_id }
    android_devices = Device.where(device_type: 'android', customer_id: customers_to_notify)
    # android_devices = Device.find_by_sql("select token, customer_id from devices d, customers c where d.customer_id = c.id and d.device_type = 'android'")
    # ios_devices = Device.find_by_sql("select token, customer_id from devices d, customers c where d.customer_id = c.id and d.device_type = 'ios'")
    ios_devices = Device.where(device_type: 'ios', customer_id: customers_to_notify)

    # Added notification
    notification = Notification.create(title: 'new tender', description: message, tender_id: self.id)

    # send android notification
    android_registration_ids = android_devices.map { |e| e.token }
    Notification.send_android_notifications(android_registration_ids, message, self.id)

    # # send iOS notification
    # ios_registration_ids = ios_devices.map { |e| e.token }
    # Notification.send_ios_notifications(ios_registration_ids, message, self.id)

    # Add customer notification for history
    CustomerNotification.add_notification_history(android_devices, ios_devices, notification)
  end

  def send_tender_update_push
    if self.saved_change_to_open_date? || self.saved_change_to_close_date?
      tender_notifications = TenderNotification.where(tender_id: self.id, notify: true)
      unless tender_notifications.empty?
        message = "Tender Dates Changed: #{self.company.try(:name)}: #{self.name}: #{self.open_date.try(:strftime, "%b,%d")} - #{self.close_date.try(:strftime, "%b,%d")}"
        customer_ids = tender_notifications.map { |e| e.customer_id }
        # Cusetomers devices
        android_devices = Device.where(customer_id: customer_ids, device_type: 'android')
        ios_devices = Device.where(customer_id: customer_ids, device_type: 'ios')

        # Added notification
        notification = Notification.create(title: 'tender date change', description: message, tender_id: self.id)

        # send android notification
        android_registration_ids = android_devices.map { |e| e.token }
        Notification.send_android_notifications(android_registration_ids, message, self.id)

        # # send iOS notification
        # ios_registration_ids = ios_devices.map { |e| e.token }
        # Notification.send_ios_notifications(ios_registration_ids, message, self.id)

        # Add customer notification for history
        CustomerNotification.add_notification_history(android_devices, ios_devices, notification)
      end
    end
  end

  def add_users_to_tender
    self.round_open_time = self.bid_open
    self.save(validate: false)
    customer_tenders = []
    Customer.all.each do |c|
      customer_tenders << {
        customer_id: c.id,
        tender_id: self.id,
        confirmed: false
      }
    end
    CustomersTender.create(customer_tenders)
  end

  # YES/NO Bidding #

  def tender_timer
    timer_value = case self.tender_type
                    when 'Blind'
                      bliding_timer
                    when 'Yes/No'
                      yn_timer
                    else
                      {'timer_value' => 0,'tender_state' => 'finished','clockFace' => 'MinuteCounter','current_round' => 0,'rounds_pass' => 0}
                  end

    return timer_value
  end

  #Prepares tender data in order to display timer
  # Returns Hash object
  def yn_timer
    result = {
        'timer_value' => 0,
        'tender_state' => '',
        'clockFace' => 'MinuteCounter',
        'current_round' => 0,
        'rounds_pass' => 0
    }
    open_bid = self.bid_open #Time.parse('2018-01-05 22:40:00')
    #Check if the tender active
    if Time.current.to_i >= self.bid_open.to_i && Time.current.to_i < self.close_date.to_i
      #Time elapsed from the beginning of tender
      elapsed_time = Time.current.to_i - open_bid.to_i
      #Round duration time in seconds
      round_duration_s = self.round_duration*60
      #Time between rounds in seconds
      rounds_between_duration_s = self.rounds_between_duration*60
      #Period of round
      round_period_s = round_duration_s + rounds_between_duration_s
      #Count of rounds that have already passed from the beginning of tender
      rounds_pass = (elapsed_time/round_period_s).floor
      #Current round period time
      period_part = elapsed_time - (round_period_s)*rounds_pass
      #Check what part of round is.
      # Round duration
      if period_part < round_duration_s
        result['timer_value'] = round_duration_s - period_part
        result['bid_status'] = true
        result['tender_state'] = 'round_active'
        result['current_round'] = rounds_pass + 1
      # Round break
      elsif period_part <= round_period_s
        result['timer_value'] = round_period_s - period_part
        result['bid_status'] = false
        result['round_start_in'] = Time.strptime((Time.current.to_i + result['timer_value']).to_s, '%s')
        result['tender_state'] = 'round_break'
        result['current_round'] = rounds_pass+1
      end
      #Puts these value for debug
      result['elapsed_time'] = elapsed_time
      result['rounds_pass'] = rounds_pass
      result['period_part'] = period_part

    #Check if tender is not started
    elsif Time.current.to_i < self.bid_open.to_i
      result['timer_value'] = self.bid_open.to_i - Time.current.to_i
      result['bid_status'] = false
      result['round_start_in'] = open_bid #Time.strptime((Time.current.to_i + result['timer_value']).to_s, '%s')
      result['tender_state'] = 'tender_wait'

    #Check if tender has alredy finished
    elsif Time.current.to_i > self.close_date.to_i
      result['bid_status'] = false
      result['tender_state'] = 'finished'
    end
    if result['timer_value'] > 3600 && result['timer_value'] < 86400
      result['clockFace'] = 'HourlyCounter'
    elsif result['timer_value'] > 86400
      result['clockFace'] = 'DailyCounter'
    end
    return result
  end

  def bliding_timer
    result = {
        'timer_value' => 0,
        'tender_state' => '',
        'clockFace' => 'MinuteCounter',
        'current_round' => 0,
        'rounds_pass' => 0
    }

    #Check if the tender active
    if Time.current.to_i >= self.bid_open.to_i && Time.current.to_i < self.close_date.to_i
      result['timer_value'] = self.close_date.to_i - self.bid_open.to_i
      result['tender_state'] = 'round_active'
    #Check if tender is not started
    elsif Time.current.to_i < self.bid_open.to_i
      result['timer_value'] = self.bid_open.to_i - Time.current.to_i
      result['round_start_in'] = Time.strptime((Time.current.to_i + result['timer_value']).to_s, '%s')
      result['tender_state'] = 'tender_wait'
    #Check if tender has alredy finished
    elsif Time.current.to_i > self.close_date.to_i
      result['tender_state'] = 'finished'
    end

    if result['timer_value'] > 3600 && result['timer_value'] < 86400
      result['clockFace'] = 'HourlyCounter'
    elsif result['timer_value'] > 86400
      result['clockFace'] = 'DailyCounter'
    end

    return result
  end

  def before_bidding_start
   if DateTime.now.to_i < self.round_open_time.to_i
    return true
  else
    return false
    end
  end

  def bidding_start
    if DateTime.now.to_i >  self.round_open_time.to_i  && (DateTime.now.to_i <  (self.round_open_time.to_i + self.round_duration.minutes))
      return true
    else
      return false
    end
  end

  def break_time
    if (DateTime.now.to_i >  (self.round_open_time.to_i + self.round_duration.minutes)) && (DateTime.now.to_i < (self.round_open_time.to_i + self.round_duration.minutes + self.rounds_between_duration.minutes))
      return true
    else
      return false
    end
  end

  def break_duration
    if self.round_open_time.present?
      if Time.current < (self.round_open_time.to_i + self.round_duration.minutes + self.rounds_between_duration.minutes)
        (self.round_open_time.to_i + self.round_duration.minutes + self.rounds_between_duration.minutes) - Time.current.to_i
      end
    end
  end

=begin
  def before_bidding_start
   if DateTime.now.to_i < self.round_open_time.to_i
    return true
  else
    return false
    end
  end
=end

  def round_duration_time
    if self.round_open_time.present?
      if Time.current < self.round_open_time.to_i
        self.round_open_time.to_i  - Time.current.to_i
      end
    end
  end

  def bidding_time
    if self.round_open_time.present?
      if Time.current < (self.round_open_time.to_i + self.round_duration.minutes)
        (self.round_open_time.to_i + self.round_duration.minutes) - Time.current.to_i
      end
    end
  end

  def update_round_open_time
    self.update_column(:round_open_time, self.bid_open)
  end

  def check_if_bid_placed(round)
    if self.diamond_type == 'Rough'
      parcels = self.stones.map { |e| e.id  }
      bids = YesNoBuyerInterest.where(stone_id: parcels, tender_id: self.id, round: round)
      if bids.empty?
        return false
      else
        return true
      end
    elsif self.diamond_type == 'Sight'
      parcels = self.sight.map { |e| e.id  }
      bids = YesNoBuyerInterest.where(sight_id: parcels, tender_id: self.id, round: round)
      if bids.empty?
        return false
      else
        return true
      end
    end
  end

  def need_to_update_time?
    if self.diamond_type == 'Rough'
      parcels = self.stones
    elsif self.diamond_type == 'Sight'
      parcels = self.sights
    end
    @count_array = []
    parcels.each_with_index do |parcel, index|
      if self.diamond_type == 'Rough'
        yes_no_buyer_interests = YesNoBuyerInterest.where(tender_id: self.id, stone_id: parcel.id, round: round - 1)
        puts yes_no_buyer_interests.count
      elsif self.diamond_type == 'Sight'
        yes_no_buyer_interests = YesNoBuyerInterest.where(tender_id: self.id, sight_id: parcel.id, round: round - 1)
      end
      if yes_no_buyer_interests.count == 1 || yes_no_buyer_interests.count == 0
        @count_array << true
      else
        @count_array << false
      end
    end
    if @count_array.include?(false)
      true
    else
      false
    end
  end

  def check_for_winners(round, current_customer)
    puts "Start winners ***********************************************************"
    puts "Round: " + round.inspect
    puts "Customer: " + current_customer.inspect
    if self.diamond_type == 'Rough'
      parcels = self.stones
    elsif self.diamond_type == 'Sight'
      parcels = self.sight
    end
    puts "Parcel: " + parcels.inspect
    parcels.each_with_index do |parcel, index|
      if self.diamond_type == 'Rough'
        yes_no_buyer_interests = YesNoBuyerInterest.where(tender_id: self.id, stone_id: parcel.id, round: round)
      elsif self.diamond_type == 'Sight'
        yes_no_buyer_interests = YesNoBuyerInterest.where(tender_id: self.id, sight_id: parcel.id, round: round)
      end
      puts "yes_no_buyer_interests: " + yes_no_buyer_interests.inspect
      puts "yes_no_buyer_interests COUNT: " + yes_no_buyer_interests.count.inspect
      if yes_no_buyer_interests.count == 1
        winning_price = parcel.yes_no_system_price.present? ? parcel.yes_no_system_price : parcel.reserved_price - ((20.to_f/100.to_f)*parcel.reserved_price)
        parcel.update_attributes(stone_winning_price: winning_price)
        if !parcel.yes_no_buyer_winner.present?
          winner = yes_no_buyer_interests.last
          puts "WINNER: " + winner.inspect
          winner = YesNoBuyerWinner.find_or_initialize_by(yes_no_buyer_interest_id: winner.id, tender_id: winner.tender_id, stone_id: winner.stone_id, sight_id: winner.sight_id, customer_id: winner.customer_id, round: winner.round, winning_price: parcel.stone_winning_price)
          winner.save
          winner_table = Winner.find_or_initialize_by(tender_id: winner.tender_id, customer_id: winner.customer_id, stone_id: winner.stone_id, sight_id: winner.sight_id)
          winner_table.save(validate: false)
        end
      elsif yes_no_buyer_interests.count > 1
        puts "NOT UPDATED: " + self.updated_after_round.inspect
        #if !self.updated_after_round
          system_price,system_price_percentage = 0.0
          if self.diamond_type == 'Rough'
            total_customers = YesNoBuyerInterest.where(stone_id: parcel.id, round: round - 1).count
            puts "total Rough = #{total_customers}"
            remaining_customers = YesNoBuyerInterest.where(stone_id: parcel.id, round: round).count
            puts "Remaining Rough= #{remaining_customers}"
          elsif self.diamond_type == ''
            total_customers = YesNoBuyerInterest.where(sight_id: parcel.id, round: round - 1).count
            puts "total Sight= #{total_customers}"
            remaining_customers = YesNoBuyerInterest.where(sight_id: parcel.id, round: round).count
            puts "Remaining Sight= #{remaining_customers}"
          end
          if round == 1
            left_customers = 0
          else
            left_customers = total_customers - remaining_customers
          end
          #left_customers = total_customers - remaining_customers
          puts "LEft = #{left_customers}"

          customer_yes_no_bid = parcel.yes_no_buyer_interests.where(tender_id: self.id, round: round).last

          if customer_yes_no_bid.present?
            reserved_price = customer_yes_no_bid.reserved_price
            if reserved_price.to_f < parcel.reserved_price.to_f
              rate = 3
              max_percent = 5
            else
              rate = 5
              max_percent = 3
            end
            system_percentage = (remaining_customers.to_f/rate.to_f*(1-left_customers.to_f/remaining_customers.to_f).to_f)
            puts "system_percentage FIRST: #{system_percentage}"
            system_percentage = [system_percentage, max_percent].min
            puts "system_percentage BEFORE LIMIT: #{system_percentage}"
            if system_percentage < 1
              system_price_percentage = 1
            elsif system_percentage > 5
              system_percentage = 5
            else
              system_price_percentage = system_percentage
            end
            puts "system_percentage = #{system_percentage}"
            puts "system_price_percentage = #{system_price_percentage}"
            @yes_no_system_price = (( 100 + system_price_percentage.to_f)/100.to_f*reserved_price.to_f).round(2)
            puts "new price = #{@yes_no_system_price}"
            parcel.update_attributes(yes_no_system_price: @yes_no_system_price)
            customer_yes_no_bid.update_attributes(reserved_price: @yes_no_system_price)
          end

        #end

      end

    end
    puts "END winners ***********************************************************"
  end
  ##################

  rails_admin do
    configure :id do
      pretty_value do
        util = bindings[:object]
        head = '<div class="modal-dialog"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title" id="myModalLabel">Tender Details</h4></div>'
        foot = '</div><div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">Close</button></div></div>'
        %{<a data-toggle="modal" onclick="$(this).modal('hide')" href="/tenders/#{self.value}/admin_details"  data-target="#modal_#{self.value.to_i}" >#{Tender.total_carat_value(self.value)}</a><div class="modal fade" id="modal_#{self.value.to_i}" role="dialog" aria-labelledby="Tender Details" aria-hidden="true" >#{head}<div class="modal-body"></div>#{foot}</div>}.html_safe
      end
    end
    configure :winner_details do
      pretty_value do
        util = bindings[:object]
        head = '<div class="modal-dialog"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title" id="myModalLabel">Winner Details</h4></div>'
        foot = '</div><div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">Close</button></div></div>'
        %{<a data-toggle="modal" onclick="$(this).modal('hide')" href="/tenders/#{self.value}/admin_winner_details"  data-target="#winner_#{self.value.to_i}" >#{Tender.total_winner_value(self.value)}</a><div class="modal fade" id="winner_#{self.value.to_i}" role="dialog" aria-labelledby="Tender Details" aria-hidden="true" >#{head}<div class="modal-body"></div>#{foot}</div>}.html_safe
      end
    end
    list do
      [:name].each do |field_name|
        field field_name
      end
      field :id do
        label "Total Carats"
      end
      field :winner_details do
        label "Winning Bid Total"
      end
      field :open_date do
        strftime_format "%Y-%m-%d"
      end
      field :close_date do
        strftime_format "%Y-%m-%d"
      end
      field :tender_open, :toggle
      field :round_duration
      field :rounds_between_duration
    end
    edit do
      field :company do
        label "Supplier"
      end
      field :supplier_mine_id, :enum do
        label "Mine"
        enum do
          SupplierMine.all.map { |c| [ c.name, c.id ] }
        end
      end
      field :name
      field :tender_type, :enum do
        enum do
          ['Blind', 'Yes/No']
        end
      end
      field :diamond_type, :enum do
        enum do
          ['Rough', 'Sight']
        end
        default_value 'Rough'
      end
      field :country do
        partial :country_list
      end
      field :city
      #      field :description, :text do
      #        bootstrap_wysihtml5 true
      #      end
      field :open_date do
        default_value Date.today
      end
      field :close_date
      field :bid_open
      field :round_duration
      field :rounds_between_duration
      field :timezone do
        partial :timezone_list
      end
      field :stones
      field :delete_stones do
        partial :delete_stones
      end
      field :sights
      field :delete_sights do
        partial :delete_sights
      end
      field :reference_id, :enum do
        label "Add Reference"
        enum do
          Tender.all.map { |c| [ c.name, c.id ] }
        end
      end
      field :tender_open do
        default_value true
      end
      # field :temp_document do
      # label "Temporary Document"
      # help "Upload Temporary Stone detail file"
      # partial :upload_temp_document
      # end
      field :sight_document do
        label "Sight Document"
        partial :slight_upload_document
      end
      field :document do
        label "Stone Document"
        partial :upload_document
      end
      [:deec_no_field, :lot_no_field, :desc_field, :no_of_stones_field,:weight_field,:sheet_no, :winner_lot_no_field, :winner_desc_field, :winner_no_of_stones_field, :winner_weight_field, :winner_selling_price_field, :winner_carat_selling_price_field,:winner_sheet_no, :reserved_field, :sheet_no, :s_no_field, :source_no_field, :box_no_field, :carats_no_field, :cost_no_field, :boxvalue_no_field, :sight_no_field, :sight_reserved_field, :price_no_field, :credit_no_field].each do |f|
        field f do
          partial :blank
        end
      end

      field :winner_list do
        partial :upload_winner_list
      end
      field :delete_winner_list do
        partial :delete_winner_list
      end
      # field :customers
    end
  end
end