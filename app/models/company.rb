class Company < ApplicationRecord

  has_many :customers, dependent: :destroy
  has_many :demands, dependent: :destroy
  has_many :polished_demands, dependent: :destroy
  has_many :trading_parcels, dependent: :destroy
  has_many :buyer_credit_limits, :foreign_key => "buyer_id", :class_name => "CreditLimit", dependent: :destroy
  has_many :buyer_transactions, :foreign_key => "buyer_id", :class_name => "Transaction", dependent: :destroy
  has_many :seller_transactions, :foreign_key => "seller_id", :class_name => "Transaction", dependent: :destroy
  has_many :buyer_days_limits, :foreign_key => "buyer_id", :class_name => "DaysLimit", dependent: :destroy
  has_many :seller_days_limits, :foreign_key => "seller_id", :class_name => "DaysLimit", dependent: :destroy
  has_many :company_group_seller, :foreign_key => "seller_id", :class_name => "CompaniesGroup", dependent: :destroy
  has_many :buyer_proposals, class_name: 'Proposal', foreign_key: 'buyer_id', dependent: :destroy
  has_many :seller_proposals, class_name: 'Proposal', foreign_key: 'seller_id', dependent: :destroy
  after_create :add_dummy_data
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  def get_owner
    Customer.unscoped do
      customers.where.not(confirmed_at: nil).order(:id).first
    end
  end

  def is_blocked_by_supplier(supplier)
    bu = BlockUser.where(company_id: supplier, block_company_ids: self.id).first
    if bu.nil?
      false
    else
      true
    end
  end

  def has_limit(supplier)
    CreditLimit.where(seller_id: supplier, buyer_id: self.id).first.present?
  end

  def has_overdue_transaction_of_30_days(supplier_id)
    dl = DaysLimit.where(buyer_id: self.id, seller_id: supplier_id).first
    if dl.nil?
      number_of_days = 30
    else
      number_of_days = dl.days_limit.to_i
    end
    date = Date.current - number_of_days.days
    if Transaction.where("buyer_id = ? AND due_date < ? AND paid = ?", self.id, date, false).present?
      true
    else
      false
    end
  end

  def check_group_overdue(supplier_id)
    is_overdue = false
    groups = CompaniesGroup.where("company_id like '%#{id}%'")
    groups.each do |group|
      group.company_id.each do |c|
        company = Company.find(c)
        if company.has_overdue_transaction_of_30_days(supplier_id)
          is_overdue = true
          return is_overdue
        end
      end
    end
    return is_overdue
  end

  def check_market_limit_overdue(market_limit_overdue, supplier_id)
    #cl = CreditLimit.where(seller_id: supplier_id, buyer_id: self.id).first
    cl = CreditLimit.find_by(seller_id: supplier_id, buyer_id: self.id)
    if cl.nil? || cl.market_limit.nil?
      return false
    else
      company_market_limit = cl.market_limit
      if market_limit_overdue.to_i < company_market_limit.to_i
        return false
      elsif company_market_limit.to_i == 0
      else
        return true
      end
    end
  end

  def is_overdue
    date = Date.current
    if Transaction.where("buyer_id = ? AND due_date < ? AND paid = ?", self.id, date, false).present?
      true
    else
      false
    end
  end

  def has_overdue_that_seller_setlimit(buyer_id)
    days_limit = self.seller_days_limits.where(buyer_id: buyer_id).first
    transaction = Transaction.where("seller_id = ? AND buyer_id = ? AND paid = ?", self.id, buyer_id, false)
    transaction.each do |t|
      overdue_days = (Date.current - t.due_date.to_date).to_i if t.due_date.present?
      if days_limit.present?
        limit = days_limit.days_limit
      else
        limit = 15
      end
      if overdue_days.to_i > limit
        return true
      end
    end
    return false
  end

  def self.get_sellers
    Company.where(is_broker: false)
  end

  def block_users
    BlockUser.where(company_id: id)
  end

  ### Brokers ###
  def sent_broker_request(seller)
    BrokerRequest.where(broker_id: self.id, seller_id: seller.id, accepted: false).first.present?
  end

  def is_broker_or_not(seller)
    BrokerRequest.where(broker_id: self.id, seller_id: seller.id, accepted: true).first.present?
  end

  def my_brokers
    BrokerRequest.where(seller_id: self.id, accepted: true)
  end

  ###############

  ##### Credit Scores #####

  def get_total_credit_score
    total = self.get_payment_history + self.get_sales_history

    return total
  end

  def get_payment_history
    scores = self.get_payment_history_ex
    return scores['total']
  end

  def get_payment_history_ex
    scores = {
        'first' => {
            'late_payments' => 0,
            'on_time_payments' => 0,
            'months_of_data' => 0,
            'total' => 0
        },
        'second' => {
            'this_month_pending_count' => 0,
            'avg_3_month_pending_count' => 0,
            'total' => 0
        },
        'third' => {
            'this_month_pending_amount' => 0,
            'avg_3_month_completed_amount' => 0,
            'total' => 0
        },
        'fourth' => {
            'total' => 0
        },
        'total' => 0
    }

    if self.buyer_transactions.count > 0
      #Calculate each section of formula

      #First
      scores['first']['late_payments'] = Transaction.overdue_received_transaction(self.id).count()
      scores['first']['on_time_payments'] = Transaction.complete_received_transaction(self.id).count()

      on_time_payments = Transaction.complete_received_transaction(self.id)
      payment_months = []
      on_time_payments.each do |t|
        unless payment_months.include?(t.due_date.mon)
          payment_months.push(t.due_date.mon)
        end
      end
      scores['first']['months_of_data'] = payment_months.count
      scores['first']['total'] = ((scores['first']['late_payments'].to_f / (scores['first']['on_time_payments'].to_f / scores['first']['months_of_data'].to_f)) * 0.25).round(2)

      #Second
      avg_month_start = Date.civil(Date.current.year, Date.current.mon-3)
      avg_month_end = Date.civil(Date.current.year, Date.current.mon-1, -1)
      month_start = Date.civil(Date.current.year, Date.current.mon)
      month_end = Date.civil(Date.current.year, Date.current.mon, -1)
      avg_unpaid = Transaction.where("buyer_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, avg_month_start, avg_month_end, false, true).count()
      scores['second']['avg_3_month_pending_count'] = (avg_unpaid.to_f/3).round(2)
      if avg_unpaid > 0
        scores['second']['this_month_pending_count'] = Transaction.where("buyer_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, month_start, month_end, false, true).count()
        scores['second']['total'] = ((scores['second']['this_month_pending_count'].to_f/scores['second']['avg_3_month_pending_count'].to_f)*0.25).round(2)
      end

      #Third
      scores['third']['avg_3_month_completed_amount'] = Transaction.where("buyer_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, avg_month_start, avg_month_end, true, true).sum(:total_amount)
      if (scores['third']['avg_3_month_completed_amount']).positive?
        scores['third']['this_month_pending_amount'] = Transaction.where("buyer_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, month_start, month_end, false, true).sum(:total_amount)
        scores['third']['total'] = ((scores['third']['this_month_pending_amount'].to_f/scores['third']['avg_3_month_completed_amount'].to_f)*0.25).round(2)
      end

      #Fourth
      seller_amount_and_score = 0
      seller_late_amount = 0
      self.buyer_transactions.each do |t|
        is_late = Transaction.includes(:trading_parcel).where("seller_id = ? AND paid = ? AND buyer_confirmed = ?", t.seller_id, false, true).count()
        if is_late.positive?
          seller_amount = Transaction.total_transaction(t.seller_id)
          seller_sales_score = Company.find(t.seller_id).get_sales_history
          seller_amount_and_score += (seller_amount.to_f * seller_sales_score.to_f).round(2)
          seller_late_amount += seller_amount
        end
      end
      if seller_late_amount.positive?
        scores['fourth']['total'] = ((seller_amount_and_score.to_f / seller_late_amount.to_f) * 0.25).round(2)
      end
      scores['total'] = 1 - scores['first']['total'] + scores['second']['total'] + scores['third']['total'] + scores['fourth']['total']
    end

    return scores
  end

  def get_sales_history
    scores = self.get_sales_history_ex

    return scores['total']
  end

  def get_sales_history_ex
    scores = {
        'first' => {
            'late_payments' => 0,
            'on_time_payments' => 0,
            'months_of_data' => 0,
            'total' => 0
        },
        'second' => {
            'this_month_pending_count' => 0,
            'avg_3_month_pending_count' => 0,
            'total' => 0
        },
        'third' => {
            'this_month_pending_amount' => 0,
            'avg_3_month_completed_amount' => 0,
            'total' => 0
        },
        'fourth' => {
            'total' => 0
        },
        'total' => 0
    }

    if self.seller_transactions.count > 0

      #Calculate each section of formula

      #First
      scores['first']['late_payments'] = Transaction.overdue_sent_transaction(self.id).count()
      scores['first']['on_time_payments'] = Transaction.complete_sent_transaction(self.id).count()

      on_time_payments = Transaction.complete_sent_transaction(self.id)
      payment_months = []
      on_time_payments.each do |t|
        unless payment_months.include?(t.due_date.mon)
          payment_months.push(t.due_date.mon)
        end
      end
      scores['first']['months_of_data'] = payment_months.count
      scores['first']['total'] = ((scores['first']['late_payments'].to_f / (scores['first']['on_time_payments'].to_f / scores['first']['months_of_data'].to_f)) * 0.25).round(2)

      #Second
      avg_month_start = Date.civil(Date.current.year, Date.current.mon-3)
      avg_month_end = Date.civil(Date.current.year, Date.current.mon-1, -1)
      month_start = Date.civil(Date.current.current, Date.current.mon)
      month_end = Date.civil(Date.current.year, Date.current.mon, -1)
      avg_unpaid = Transaction.where("seller_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, avg_month_start, avg_month_end, false, true).count()
      scores['second']['avg_3_month_pending_count'] = (avg_unpaid.to_f/3).round(2)
      if avg_unpaid > 0
        scores['second']['this_month_pending_count'] = Transaction.where("seller_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, month_start, month_end, false, true).count()
        scores['second']['total'] = ((scores['second']['this_month_pending_count'].to_f/scores['second']['avg_3_month_pending_count'].to_f)*0.25).round(2)
      end

      #Third
      scores['third']['avg_3_month_completed_amount'] = Transaction.where("seller_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, avg_month_start, avg_month_end, true, true).sum(:total_amount)
      if (scores['third']['avg_3_month_completed_amount']).positive?
        scores['third']['this_month_pending_amount'] = Transaction.where("seller_id = ? AND created_at >= ? AND created_at <= ? AND paid = ? AND buyer_confirmed = ?", self.id, month_start, month_end, false, true).sum(:total_amount)
        scores['third']['total'] = ((scores['third']['this_month_pending_amount'].to_f/scores['third']['avg_3_month_completed_amount'].to_f)*0.25).round(2)
      end

      #Fourth
      buyer_amount_and_score = 0
      buyer_late_amount = 0
      self.seller_transactions.each do |t|
        is_late = Transaction.includes(:trading_parcel).where("buyer_id = ? AND paid = ? AND buyer_confirmed = ?", t.buyer_id, false, true).count()
        if is_late.positive?
          buyer_amount = Transaction.total_transaction(t.buyer_id)
          buyer_sales_score = Company.find(t.buyer_id).get_payment_history
          buyer_amount_and_score += (buyer_amount.to_f * buyer_sales_score.to_f).round(2)
          buyer_late_amount += buyer_amount
        end
      end
      if buyer_late_amount.positive?
        scores['fourth']['total'] = ((buyer_amount_and_score.to_f / buyer_late_amount.to_f) * 0.25).round(2)
      end

      scores['total'] = 1 - scores['first']['total'] + scores['second']['total'] + scores['third']['total'] + scores['fourth']['total']
    end


    return scores
  end

  def get_activity
    c = Date.current.day
    #TODO - set default value for start date
    date_start = 0
    if (c-30).positive?
      date_start = Date.civil(Date.current.year, Date.current.mon, (c - 30).to_i)
    else
      date_start = Date.civil(Date.current.year, Date.current.mon - 1, (Date.civil(Date.current.year, Date.current.mon-1, -1).day - 29 + c))
    end
    avg_month_start = Date.civil(Date.current.year, Date.current.mon-3)
    avg_month_end = Date.civil(Date.current.year, Date.current.mon-1, -1)

    last_transactions = Transaction.where("( seller_id = ? or buyer_id = ? ) AND created_at >= ? AND created_at <= ? AND buyer_confirmed = ?", self.id, self.id, date_start, Date.current, true)
    avg_transactions = Transaction.where("( seller_id = ? or buyer_id = ? ) AND created_at >= ? AND created_at <= ? AND buyer_confirmed = ?", self.id, self.id, avg_month_start, avg_month_end, true)

    scores = {
        'last_transaction_count' => last_transactions.count(),
        'avg_transaction_count' => (avg_transactions.count/3).round(2),
        'last_transaction_amount' => last_transactions.sum(:total_amount),
        'avg_transaction_amount' => (avg_transactions.sum(:total_amount)/3).round(2)
    }

    return scores

  end

  # Calculate "Network Diversity" for one company
  def business_with_company(company_id)
    result = {
        'company_name' => '',
        'company_business_amount_as_buyer' => 0,
        'company_business_amount_as_seller' => 0,
        'my_business_amount' => 0,
        'total' => 0
    }
    result['my_business_amount'] = Transaction.total_transaction(self.id).sum(:total_amount)
    result['company_name'] = Company.find(company_id).name
    if result['my_business_amount'].positive?
      result['company_business_amount_as_seller'] = Transaction.where("buyer_id = ? AND seller_id = ? AND buyer_confirmed = ?", company_id, self.id, true).sum(:total_amount).to_f
      result['company_business_amount_as_buyer'] = Transaction.where("buyer_id = ? AND seller_id = ? AND buyer_confirmed = ?", self.id, company_id, true).sum(:total_amount).to_f

      result['total'] = ((result['company_business_amount_as_seller'] + result['company_business_amount_as_buyer']) / result['my_business_amount']).round(2)
    end
    return result
  end

  def add_dummy_data
    # Add Dummy Companies
    dummy_co_1 = Company.where(name: 'Dummy co. 1', county: 'India').first
    dummy_co_2 = Company.where(name: 'Dummy co. 2', county: 'India').first
    dummy_co_3 = Company.where(name: 'Dummy co. 3', county: 'India').first

    rough_parcel1 = {
        company_id: id,
        credit_period: 30,
        diamond_type: 'Rough',
        description: 'Dummy Parcel for Demo',
        weight: 10,
        price: 10,
        source: 'OutSide Goods',
        box: 2,
        cost: 10,
        box_value: '12',
        sight: '07/18',
        percent: 0,
        comment: 'This is a Demo Parcel',
        total_value: 100,
        sale_demanded: true
    }
    rough_parcel2 = {
        company_id: id,
        credit_period: 30,
        diamond_type: 'Rough',
        description: 'Dummy Parcel for Demo',
        weight: 10,
        price: 10,
        source: 'OutSide Goods',
        box: 2,
        cost: 10,
        box_value: '12',
        sight: '07/18',
        percent: 0,
        comment: 'This is a Demo Parcel',
        total_value: 100,
        sale_demanded: true,
        sold: true
    }
    trading_parcel1 = TradingParcel.new(rough_parcel1)
    trading_parcel1.save(:validate => false)
    trading_parcel2 = TradingParcel.new(rough_parcel2)
    trading_parcel2.save(:validate => false)

    polished_parcel = {
        no_of_stones: 0,
        weight: 10,
        credit_period: 30,
        price: 10,
        company_id: id,
        cost: 10,
        box_value: '0',
        source: 'POLISHED',
        diamond_type: 'Polished',
        sale_demanded: true,
        percent: 0,
        comment: 'This is Dummy Polished Parcel',
        total_value: 240,
        shape: 'Round',
        color: 'M',
        clarity: 'SI3',
        cut: 'Good',
        polish: 'Excellent',
        symmetry: 'Excellent',
        fluorescence: 'None',
        lab: 'GCAL',
        city: 'Kabul',
        country: 'Afghanistan'
    }
    trading_parcel3 = TradingParcel.new(polished_parcel)
    trading_parcel3.save(:validate => false)

    demand1 = {description: 'Dummy Parcel for Demo', demand_supplier_id: 1, block: 0,
               deleted: 0, company_id: id
    }
    demand2 = {
        description: 'Dummy Parcel for Demo',
        demand_supplier_id: 2, block: 0, deleted: 0,
        company_id: id
    }
    demand3 = {
        description: 'Dummy Parcel for Demo', demand_supplier_id: 3, block: 0, deleted: 0,
        company_id: id
    }
    Demand.create(demand1)
    Demand.create(demand2)
    Demand.create(demand3)

    transaction1 =
        {
            seller_id: id,
            buyer_id: dummy_co_1.id,
            trading_parcel_id: trading_parcel2.id,
            due_date: Date.current + (trading_parcel2.credit_period).days,
            price: 10,
            transaction_type: 'manual',
            credit: 30,
            paid: 0,
            buyer_confirmed: 1,
            diamond_type: 'Rough',
            description: trading_parcel2.description,
            created_at: Time.now
        }
    transaction2 = {
        seller_id: id,
        buyer_id: dummy_co_1.id,
        trading_parcel_id: trading_parcel2.id,
        due_date: Date.current - (trading_parcel2.credit_period).days,
        price: 10,
        transaction_type: 'manual',
        credit: 30,
        paid: 0,
        buyer_confirmed: 1,
        diamond_type: 'Rough',
        created_at: Time.now
    }
    transaction3 = {
        seller_id: id,
        buyer_id: dummy_co_1.id,
        trading_parcel_id: trading_parcel2.id,
        due_date: Date.current + (trading_parcel2.credit_period).days,
        price: 10,
        transaction_type: 'manual',
        credit: 30,
        paid: 1,
        buyer_confirmed: 1,
        diamond_type: 'Rough',
        created_at: Time.now
    }
    Transaction.create(transaction1)
    Transaction.create(transaction2)
    Transaction.create(transaction3)
    # CompaniesGroup.new

    company_group = {
        group_name: 'Dummy Group',
        seller_id: id,
        company_id: [dummy_co_1.id, dummy_co_2.id],
        group_market_limit: 200,
        group_overdue_limit: 300
    }
    CompaniesGroup.create(company_group)
    CreditLimit.where(buyer_id: dummy_co_3.id, seller_id: id, credit_limit: 300).first_or_create
    DaysLimit.where(buyer_id: dummy_co_3.id, seller_id: id, days_limit: 25).first_or_create
    return 0

  rescue => e
  end

  def get_buyer_score
    return BuyerScore.get_score(self.id)
  end

  def get_seller_score
    return SellerScore.get_score(self.id)
  end

  def self.add_historical_data(buyer_id, seller_id, credit_limit, market_limit, overdue_limit)
    historical_record = HistoricalRecord.new(buyer_id: buyer_id, seller_id: seller_id, total_limit: credit_limit, market_limit: market_limit, overdue_limit: overdue_limit, date: Date.current)
    historical_record.save
    return historical_record.id
  end

  def increase_market_limit(market_limit_overdue, buyer_id, parcel)
    cl = CreditLimit.where(seller_id: self.id, buyer_id: buyer_id).first
    cl.market_limit = market_limit_overdue.to_i + 1000
    Message.accept_limit_increase(buyer_id, parcel) if cl.save
  end

  def increase_overdue_limit(buyer_id, parcel)
    dl = DaysLimit.where(buyer_id: buyer_id, seller_id: self.id).first
    if dl.nil?
      number_of_days = 30
    else
      number_of_days = dl.days_limit.to_i
    end
    date = Date.current - number_of_days.days
    oldest_transaction = Transaction.where("buyer_id = ? AND due_date < ? AND paid = ?", buyer_id, date, false).order(:due_date).first
    new_limit = Date.current - oldest_transaction.due_date.to_date + 5
    if dl
      dl.days_limit = new_limit
      dl.save
    else
      DaysLimit.create(buyer_id: buyer_id, seller_id: self.id, days_limit: new_limit)
    end
    Message.accept_limit_increase(buyer_id, parcel)
  end

  def supplier_connected
    #dummy_co = Company.where(name: "Dummy co. 1").first
    self.buyer_transactions.select(:seller_id).where("created_at>= #{(Date.current - 90.day)}").where(paid: true).uniq.count
  end

  def supplier_paid
    supplier_connected
  end

  def supplier_unpaid
    buyer_transactions.select(:seller_id).where(paid: false).uniq.count
  end

  def send_notification(type_of_event, customers_to_notify)
    customers_to_notify.each do |customer|
      android_devices = Device.where(device_type: 'android', customer_id: customer)
      ios_devices = Device.where(device_type: 'ios', customer_id: customer)
      full_message = PushNotification.where(type_of_event: type_of_event).first
      android_registration_ids = android_devices.map {|e| e.token}
      Notification.send_android_notifications(android_registration_ids, full_message, nil)
    end
  end

  ##### End of Credit Scores #####

  rails_admin do
    edit do
      field :name
      field :city
      field :county
      field :is_anonymous
      field :is_broker
      field :add_polished
    end
  end
end
