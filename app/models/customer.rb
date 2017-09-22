class Customer < ApplicationRecord
  paginates_per 25
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  # validates :auth_token, uniqueness: true
  # before_create :generate_authentication_token!

  has_many :customers_tenders
  has_many :tenders, :through => :customers_tenders
  has_many :bids
  has_many :winners
  has_many :notes
  has_many :devices
  has_many :companies
  has_one :block_user

  # accepts_nested_attributes_for :companies

  has_many :customer_ratings
  has_many :customer_comments
  has_many :customer_pictures
  has_many :trading_parcels
  has_many :buyer_transactions, :foreign_key => "buyer_id", :class_name => "Transaction"
  has_many :supplier_transactions, :foreign_key => "supplier_id", :class_name => "Transaction"
  has_many :buyer_credit_limits, :foreign_key => "buyer_id", :class_name => "CreditLimit"
  has_many :supplier_credit_limits, :foreign_key => "supplier_id", :class_name => "CreditLimit"

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me,
  #                 :first_name, :last_name,
  #                 :city, :address ,:postal_code,
  #                 :phone, :status, :tender_ids,
  #                 :phone_2,:mobile_no, :company,:company_address

  # attr_accessible :title, :body
  # validates :phone,
  #           :format => {:with => /^\d{10}$/, multiline: true},
  #           :unless => proc{|obj| obj.phone.blank?} , :reduce => true

  # validates :phone_2,
  #           :format => {:with => /^\d{10}$/, multiline: true},
  #           :unless => proc{|obj| obj.phone_2.blank?} , :reduce => true

  validates :mobile_no, uniqueness: true,
            :format => {:with => /^\d{10}$/, multiline: true},
            :unless => proc{|obj| obj.mobile_no.blank?} , :reduce => true

  # validates :email,
  #           :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, multiline: true },
  #           :presence => true, :reduce => true ,
  #           :on => :create

  # validates :city, :company,:company_address , :first_name, :last_name,
  #           :presence => true , :reduce => true

  after_create :send_account_creation_mail, :add_user_to_tenders
  default_scope { order("first_name asc, last_name asc") }

  validates :first_name, :company, :mobile_no, :presence => true
  # def generate_authentication_token! customer
  #   begin
  #     customer.auth_token = Devise.friendly_token
  #   end #while self.class.exists?(auth_token: auth_token)
  # end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["mobile_no = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def tender_history
    self.tenders.where(:id => self.bids.map(&:tender_id))
  end

  def send_account_creation_mail
    TenderMailer.account_creation_mail(self).deliver  rescue logger.info "Error sending email"
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.where(authentication_token: token).first
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def has_overdue_transaction_of_30_days
    date = Date.today - 30.days
    if Transaction.where("buyer_id = ? AND due_date < ? AND paid = ?", self.id, date, false).present?
      true
    else
      false
    end
  end

  def is_blocked_by_supplier(supplier)
    bu = BlockUser.where(customer_id: supplier).first
    if bu.nil?
      false  
    else
      if bu.block_user_ids.include?(self.id.to_s)
        true
      else
        false
      end
    end
  end

  def has_limit(supplier)
    CreditLimit.where(supplier_id: supplier, buyer_id: self.id).first.present?
  end

  def add_user_to_tenders
    customer_tenders = []
    Tender.all.each do |t|
      customer_tenders << {
        customer_id: self.id,
        tender_id: t.id,
        confirmed: false
      }
    end
    CustomersTender.create(customer_tenders)
  end

  rails_admin do
    list do
      [:email, :first_name, :last_name, :mobile_no, :city, :company, :company_address].each do |field_name|
        field field_name
      end
    end
    show do
      [:id, :email, :first_name, :last_name, :city, :address, :phone, :phone_2,:mobile_no, :company,:company_address].each do |field_name|
        field field_name
      end
    end
    edit do
      field :email
      field :password
      field :password_confirmation do
        help 'Length of 8-128.'
      end
      field :first_name
      field :last_name
      field :city
      field :address
      field :phone
      field :phone_2
      field :mobile_no
      field :company
      field :company_address
      field :phone
      field :status
    end
  end

end

