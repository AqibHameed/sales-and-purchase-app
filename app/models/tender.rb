class Tender < ApplicationRecord
  paginates_per 25

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

  accepts_nested_attributes_for :stones

  # validates_presence_of :name, :open_date, :close_date, :company_id, :country

  has_attached_file :temp_document
  do_not_validate_attachment_file_type :temp_document
  has_attached_file :document
  do_not_validate_attachment_file_type :document
  has_attached_file :winner_list
  do_not_validate_attachment_file_type :winner_list

  after_save :create_stones_from_uploaded_file
  # after_save :create_temp_stones_from_uploaded_file #==> remove on Nov 15 2013
  after_save :update_winner_list_from_uploaded_file

  after_create :send_tender_create_push
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
    #    self.bids.map(&:total).sum rescue 0
    Bid.where(:stone_id => self.stone_ids, :customer_id => customer.id).map(&:total).sum.round(2) rescue 0
  end

  def create_stones_from_uploaded_file
    if self.document_updated_at_changed?
      data_file = Spreadsheet.open(self.document.path)
      worksheet = data_file.worksheet(self.sheet_no.to_i - 1)
      unless worksheet.nil?
        worksheet.each_with_index do |data_row, i|
          unless i == 0
            unless data_row[('A'..'AZ').to_a.index(self.lot_no_field)].nil?
              stone = self.stones.find_or_initialize_by(lot_no: Tender.get_value(data_row[Tender.get_index(self.lot_no_field)]))
              stone.deec_no = Tender.get_value(data_row[Tender.get_index(self.deec_no_field)]) unless self.deec_no_field.blank?
              stone.description = Tender.get_value(data_row[Tender.get_index(self.desc_field)]) unless self.desc_field.blank?
              stone.no_of_stones = Tender.get_value(data_row[Tender.get_index(self.no_of_stones_field)].to_i) unless self.no_of_stones_field.blank?
              stone.weight = Tender.get_value(data_row[Tender.get_index(self.weight_field)].to_f) unless self.weight_field.blank?
              stone.stone_type = (data_row[Tender.get_index(self.no_of_stones_field)].to_i == 1 ? 'Stone' : 'Parcel' rescue 'Stone'  ) unless self.no_of_stones_field.blank?
              stone.save
              puts stone.errors.full_messages
            end
          end
        end
      end
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
        data_file = Spreadsheet.open(self.winner_list.path)
        worksheet = data_file.worksheet(self.winner_sheet_no.to_i - 1)
        unless worksheet.nil?
          worksheet.each_with_index do |data_row, i|
            unless data_row[Tender.get_index(self.winner_lot_no_field)].nil?
              lot_no = Tender.get_value(data_row[Tender.get_index(self.winner_lot_no_field)])
              win = self.tender_winners.find_or_initialize_by(lot_no: lot_no)
              win.description = data_row[Tender.get_index(self.winner_desc_field)]
              win.selling_price = Tender.get_value(data_row[Tender.get_index(self.winner_selling_price_field)])
              # actual_selling_price = Tender.get_value(data_row[Tender.get_index(self.winner_selling_price_field)])
              # check_selling_price(actual_selling_price)
              win.avg_selling_price = Tender.get_value(data_row[Tender.get_index(self.winner_carat_selling_price_field)])
              win.save
            end
          end
          Tender.send_winner_list_uploaded_mail(self.id)
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
      TenderMailer.send_winner_list_uploaded_mail(tender, c).deliver rescue logger.info "Error sending email"
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

  def self.search_results(filters, current_customer, history_page = false)
    query = []
    unless filters.blank?
      query << "tenders.id in (#{Array(filters[:name]).join(',')})" unless filters[:name].blank?
      query << "tenders.open_date >= '#{filters[:start_date].to_datetime.beginning_of_day}'" unless filters[:start_date].blank?
      query << "tenders.close_date <= '#{filters[:end_date].to_datetime.end_of_day}'" unless filters[:end_date].blank?
      query << "(tenders.open_date <= '#{filters[:specific_date].to_datetime.end_of_day}' AND tenders.open_date >= '#{filters[:specific_date].to_datetime.beginning_of_day}') OR (close_date <= '#{filters[:specific_date].to_datetime.end_of_day}' AND close_date >= '#{filters[:specific_date].to_datetime.beginning_of_day}')" unless filters[:specific_date].blank?
      query << "stones.stone_type like '%#{filters[:type]}%'" unless filters[:type].blank?
      query << "stones.description like '%#{filters[:description]}%'" unless filters[:description].blank?
      query << "stones.weight like '%#{filters[:size]}%'" unless filters[:size].blank?
      query << "stones.carat = '#{filters[:carat]}'" unless filters[:carat].blank?
      query << "stones.color = '#{filters[:color]}'" unless filters[:color].blank?
      query << "stones.purity = '#{filters[:purity]}'" unless filters[:purity].blank?
    end
    query = query.join(' AND ')
    if history_page
      if current_customer
        Stone.joins(:tender, :bids => :customer).where("customer_id = #{current_customer.id}").where(query)
      else
        Stone.joins(:tender, :bids => :customer).where(query)
      end
    else
      if current_customer.blank?
        Tender.joins(:stones).where(query)
      else
        current_customer.tenders.joins(:stones).where(query)
      end
    end
  end

  def self.send_open_notification
    @tenders = Tender.opening_today
    @tenders.each do |tender|
      unless tender.created_at.beginning_of_day <= tender.open_date && tender.open_date <= tender.created_at.end_of_day
        tender.customers.each do |customer|
          TenderMailer.send_tender_open_notification(tender, customer).deliver rescue logger.info "Error sending email"
        end
      end
    end
  end

  def self.send_close_notification
    @tenders = Tender.closing_today
    @tenders.each do |tender|
      Admin.all.each do |admin|
        TenderMailer.send_tender_close_notification(tender, admin).deliver rescue logger.info "Error sending email"
      end
      tender.customers.each do |customer|
        TenderMailer.send_tender_close_notification(tender, customer).deliver rescue logger.info "Error sending email"
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
    tender.stones.each do |s|
      sum = sum + s.weight.round(2) rescue 0.0
    end
    return sum.round(2)
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
    fcm = FCM.new(ENV['FCM_KEY'])
    all_devices = Device.find_by_sql("select token, customer_id from devices d, customers c where d.customer_id = c.id and d.device_type = 'android'")
    registration_ids = all_devices.map { |e| e.token }

    options = { data: { message: message }, collapse_key: "IDT" }
    response = fcm.send(registration_ids, options)
    data = all_devices.map { |e| { title: 'new tender', description: message, tender_id: self.id, customer_id: e.customer_id }}
    Notification.create(data) unless data.empty?
    status = true if response[:body]["success"] == 1
  end

  def send_tender_update_push
    if self.open_date_changed? || self.close_date_changed?
      message = "Tender Dates Changed: #{self.company.try(:name)}: #{self.name}: #{self.open_date.try(:strftime, "%b,%d")} - #{self.close_date.try(:strftime, "%b,%d")}"
      fcm = FCM.new(ENV['FCM_KEY'])
      all_devices = Device.find_by_sql("select token from devices d, customers c where d.customer_id = c.id and d.device_type = 'android'")
      registration_ids = all_devices.map { |e| e.token }
      options = { data: {message: message}, collapse_key: "IDT" }
      response = fcm.send(registration_ids, options)

      data = all_devices.map { |e| { title: 'tender date change', description: message, tender_id: self.id, customer_id: e.customer_id }}
      Notification.create(data) unless data.empty?
      status = true if response[:body]["success"] == 1
    end
  end

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
    end
    edit do
      field :company
      field :name
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
      field :stones
      field :delete_stones do
        partial :delete_stones
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
      field :document do
        label "Stone Document"
        partial :upload_document
      end
      [:deec_no_field, :lot_no_field, :desc_field, :no_of_stones_field,:weight_field,:sheet_no, :winner_lot_no_field, :winner_desc_field, :winner_no_of_stones_field, :winner_weight_field, :winner_selling_price_field, :winner_carat_selling_price_field,:winner_sheet_no].each do |f|
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
      field :customers
    end
  end
end