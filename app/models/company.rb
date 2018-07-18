class Company < ApplicationRecord
  has_many :customers, dependent: :destroy
  has_many :trading_parcels, dependent: :destroy
  has_many :buyer_credit_limits, :foreign_key => "buyer_id", :class_name => "CreditLimit", dependent: :destroy
  has_many :buyer_transactions, :foreign_key => "buyer_id", :class_name => "Transaction", dependent: :destroy
  has_many :seller_transactions, :foreign_key => "seller_id", :class_name => "Transaction", dependent: :destroy

  has_many :buyer_proposals, class_name: 'Proposal', foreign_key: 'buyer_id', dependent: :destroy
  has_many :seller_proposals, class_name: 'Proposal', foreign_key: 'seller_id', dependent: :destroy
  has_many :polished_demands
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
      customers.order(:id).first
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

end
