class Company < ApplicationRecord

  has_many :customers, dependent: :destroy
  has_many :demands, dependent: :destroy
  has_many :polished_demands, dependent: :destroy
  has_many :trading_parcels, dependent: :destroy
  has_many :buyer_credit_limits, :foreign_key => "buyer_id", :class_name => "CreditLimit", dependent: :destroy
  has_many :buyer_transactions, :foreign_key => "buyer_id", :class_name => "Transaction", dependent: :destroy
  has_many :seller_transactions, :foreign_key => "seller_id", :class_name => "Transaction", dependent: :destroy
  has_many :buyer_days_limits, :foreign_key => "buyer_id", :class_name => "DaysLimit", dependent: :destroy
  has_many :seller_days_limits, :foreign_key => "buyer_id", :class_name => "DaysLimit", dependent: :destroy
  has_many :company_group_seller, :foreign_key => "seller_id", :class_name => "CompaniesGroup", dependent: :destroy
  has_many :buyer_proposals, class_name: 'Proposal', foreign_key: 'buyer_id', dependent: :destroy
  has_many :seller_proposals, class_name: 'Proposal', foreign_key: 'seller_id', dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.import(file)
    data_file = Spreadsheet.open(open(file))
    worksheet = data_file.worksheet(0)
    unless worksheet.nil?
      worksheet.each_with_index do |row, i|
        unless i == 0
          if row[0].nil? && row[1].nil?
            return true
          else
            Company.where(name: row[0].strip , county: row[1].strip).first_or_create
          end
        end
      end
    end
  end

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
    date = Date.today - number_of_days.days
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
    cl = CreditLimit.where(seller_id: supplier_id, buyer_id: self.id).first
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
    date = Date.today
    if Transaction.where("buyer_id = ? AND due_date < ? AND paid = ?", self.id, date, false).present?
      true
    else
      false
    end
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
      scores['first']['total'] = ((scores['first']['late_payments'].to_f / (scores['first']['on_time_payments'].to_f / scores['first']['months_of_data'].to_f) ) * 0.25).round(2)

      #Second
      avg_month_start = Date.civil(Date.today.year, Date.today.mon-3)
      avg_month_end = Date.civil(Date.today.year, Date.today.mon-1, -1)
      month_start = Date.civil(Date.today.year, Date.today.mon)
      month_end = Date.civil(Date.today.year, Date.today.mon, -1)
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
      scores['first']['total'] = ((scores['first']['late_payments'].to_f / (scores['first']['on_time_payments'].to_f / scores['first']['months_of_data'].to_f) ) * 0.25).round(2)

      #Second
      avg_month_start = Date.civil(Date.today.year, Date.today.mon-3)
      avg_month_end = Date.civil(Date.today.year, Date.today.mon-1, -1)
      month_start = Date.civil(Date.today.year, Date.today.mon)
      month_end = Date.civil(Date.today.year, Date.today.mon, -1)
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
    c = Date.today.day
    #TODO - set default value for start date
    date_start = 0
    if (c-30).positive?
      date_start = Date.civil(Date.today.year, Date.today.mon, (c - 30).to_i)
    else
      date_start =  Date.civil(Date.today.year, Date.today.mon - 1, (Date.civil(Date.today.year, Date.today.mon-1, -1).day - 29 + c))
    end
    avg_month_start = Date.civil(Date.today.year, Date.today.mon-3)
    avg_month_end = Date.civil(Date.today.year, Date.today.mon-1, -1)

    last_transactions = Transaction.where("( seller_id = ? or buyer_id = ? ) AND created_at >= ? AND created_at <= ? AND buyer_confirmed = ?", self.id,self.id, date_start, Date.today, true)
    avg_transactions = Transaction.where("( seller_id = ? or buyer_id = ? ) AND created_at >= ? AND created_at <= ? AND buyer_confirmed = ?", self.id, self.id,avg_month_start, avg_month_end, true)

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

      result['total'] = ( (result['company_business_amount_as_seller'] + result['company_business_amount_as_buyer']) / result['my_business_amount'] ).round(2)
    end


    return result
  end


  def get_buyer_score
    return BuyerScore.get_score(self.id)
  end

  def get_seller_score
    return SellerScore.get_score(self.id)
  end

  ##### End of Credit Scores #####

end
