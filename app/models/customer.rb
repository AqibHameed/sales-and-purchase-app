class Customer < ApplicationRecord
  paginates_per 25
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  attr_accessor :login, :role

  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  default_scope { where(invitation_token: nil).order("first_name asc, last_name asc") }

  belongs_to :company
  acts_as_paranoid

  TILES = ['smart_search', 'sell', 'inbox', 'history', 'live_monitor', 'public_channels', 'feedback', 'share_app', 'invite',
           'current_tenders', 'upcoming_tenders', 'protection', 'record_sale', 'past_tenders'].freeze

  has_one  :sub_company_credit_limit, :foreign_key => "sub_company_id"

  has_many :bids
  has_many :devices
  has_many :winners
  has_many :broker_invites
  has_many :trading_parcels, dependent: :destroy
  has_many :email_attachments
  has_many :yes_no_buyer_winners
  has_many :yes_no_buyer_interests
  has_many :notes, dependent: :destroy
  has_many :credit_requests, dependent: :destroy
  has_many :customer_roles, dependent: :destroy
  has_many :customer_ratings, dependent: :destroy
  has_many :customer_comments, dependent: :destroy
  has_many :customer_pictures, dependent: :destroy
  has_many :customers_tenders, dependent: :destroy
  has_many :tenders, :through => :customers_tenders
  has_many :customer_notifications, dependent: :destroy
  has_many :sender, :class_name => 'Message', :foreign_key => 'sender_id'
  has_many :receiver, :class_name => 'Message', :foreign_key => 'receiver_id'
  has_many :shared_to_users, :class_name => 'Shared', :foreign_key => 'shared_to_id'
  has_many :shared_by_users, :class_name => 'Shared', :foreign_key => 'shared_by_id'
  has_many :seller_credit_limits, :foreign_key => "seller_id", :class_name => "CreditLimit"
  has_many :supplier_notifications, :foreign_key => "supplier_id", :class_name => "SupplierNotification"
  has_many :buyer_days_limits, :foreign_key => "buyer_id", :class_name => "DaysLimit"
  has_many :seller_days_limits, :foreign_key => "seller_id", :class_name => "DaysLimit"
  has_many :brokers, :foreign_key => "broker_id", :class_name => "BrokerRequest"
  has_many :sellers, :foreign_key => "seller_id", :class_name => "BrokerRequest"
  has_many :sellers, :foreign_key => "seller_id", :class_name => "CompaniesGroup"
  has_one  :tiles_count

  validates :mobile_no, uniqueness: true
  validates :first_name, :mobile_no, :presence => true
  validates :role, :presence => true, on: :create

  # send_account_creation_mail
  # Callback add_user_to_tenders
  after_create :create_update_firebase_user unless  Rails.env == 'test'
  after_create :assign_role_to_customer, :check_for_confirmation
  after_destroy :delete_firebase_user
  after_update :create_update_firebase_user unless  Rails.env == 'test'
  after_invitation_accepted :set_roles_to_customer

  has_attached_file :certificate
  do_not_validate_attachment_file_type :certificate

  accepts_nested_attributes_for :credit_requests, :allow_destroy => true

  def check_for_confirmation
    owner = company.customers.where("confirmed_at is NOT NULL").first
    if company.customers.count > 1 && owner.present?
      self.skip_confirmation!
      self.is_requested = true
      self.save(validate: false)
      CustomerMailer.request_access_mail(owner).deliver  rescue logger.info "Error sending email"
    end
  end

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

  # def has_overdue_transaction_of_30_days(supplier_id)
  #   dl = DaysLimit.where(buyer_id: self.id, seller_id: supplier_id).first
  #   if dl.nil?
  #     number_of_days = 30
  #   else
  #     number_of_days = dl.days_limit.to_i
  #   end
  #   date = Date.today - number_of_days.days
  #   if Transaction.where("buyer_id = ? AND due_date < ? AND paid = ?", self.id, date, false).present?
  #     true
  #   else
  #     false
  #   end
  # end

  # def is_blocked_by_supplier(supplier)
  #   bu = BlockUser.where(customer_id: supplier, block_user_ids: self.id).first
  #   if bu.nil?
  #     false
  #   else
  #     true
  #   end
  # end

  # def has_limit(supplier)
  #   CreditLimit.where(seller_id: supplier, buyer_id: self.id).first.present?
  # end

  ### callbacks ###
  def add_user_to_tenders
    customer_tenders = []
    Tender.all.each do |t|
      customer_tenders << {
        customer_id: self.id,
        tender_id: t.id,
        confirmed: false
      }
      if t.tender_type == "Yes/No"
        if t.diamond_type == "Rough"
          parcels = t.stones
          parcels.each do |p|
            yes_no_buyer_interests = YesNoBuyerInterest.find_or_initialize_by(tender_id: t.id, stone_id: p.id, customer_id: self.id, bid_open_time: t.bid_open, bid_close_time: t.bid_close, round: 1)
            #yes_no_buyer_interests.reserved_price = p.reserved_price - ((20.to_f/100.to_f)*p.reserved_price) rescue 0
            yes_no_buyer_interests.reserved_price = p.starting_price rescue 0
            yes_no_buyer_interests.save
          end
        else
          parcels = t.sights
          parcels.each do |p|
            yes_no_buyer_interests = YesNoBuyerInterest.find_or_initialize_by(tender_id: t.id, sight_id: p.id, customer_id: self.id, bid_open_time: t.bid_open, bid_close_time: t.bid_close, round: 1)
            #yes_no_buyer_interests.reserved_price = p.sight_reserved_price - ((20.to_f/100.to_f)*p.sight_reserved_price) rescue 0
            yes_no_buyer_interests.reserved_price = p.starting_price rescue 0
            yes_no_buyer_interests.save
          end
        end
      end
    end
    CustomersTender.create(customer_tenders)
  end

  def assign_role_to_customer
    customer_role = Role.find_by(name: self.role)
    if self.role == Role::TRADER
      CustomerRole.create(role_id: customer_role.id, customer_id: self.id)
    elsif self.role == Role::BROKER
      CustomerRole.create(role_id: customer_role.id, customer_id: self.id)
      company.update(is_broker: true)
    end
    invite = BrokerInvite.where(email: self.email).first
    if invite.nil?
    else
      BrokerRequest.create(broker_id: invite.customer_id, seller_id: id, accepted: true)
    end
  end

  def create_update_firebase_user
    begin
      response = RestClient.post 'https://clarity-staging.firebaseapp.com/addUsers?key=d99ae5a131f1fe94f673aaaf0605a36633a1a22d', [{ userUid: id.to_s, email: email.to_s, first_name: first_name.to_s, last_name: last_name.to_s, company: self.company.name.to_s, mobile_no: mobile_no.to_s, address: address.to_s, city: city.to_s, postal_code: postal_code.to_s}].to_json, {content_type: :json}
      data = JSON.parse(response)
      # self.update_attributes(firebase_uid: data["user"]["uid"])
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end
  end

  def delete_firebase_user
    begin
      response = RestClient.delete 'https://clarity-staging.firebaseapp.com/deleteUser?key=d99ae5a131f1fe94f673aaaf0605a36633a1a22d&uid='+id.to_s
      data = JSON.parse(response)
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end
  end

  ### callbacks ###
  def notify_by_supplier supplier
    SupplierNotification.where(customer_id: self.id, supplier_id: supplier.id).first.notify rescue false
  end

  def credit_days_by_supplier(supplier)
    DaysLimit.where(seller_id: supplier.id, buyer_id: self.id).first.days_limit rescue 30
  end

  def has_role?(role_name)
    role = Role.where(name: role_name).first
    unless role.nil?
      customer_role = CustomerRole.where(customer_id: self.id, role_id: role.id).first
      if customer_role.present?
        return true
      else
        return false
      end
    end
  end

  def block_demands
    Demand.where(customer_id: self.id).update_all(block: true)
  end

  def unblock_demands
    Demand.where(customer_id: self.id).update_all(block: false)
  end

  ## YES/NO ##
  def can_bid_on_parcel(type, round, tender, stone)
    #always allow on the first round
    if round == 1
      return true
    end
    #check placing bids by type of diamond
    if type == 'stone'
      return YesNoBuyerInterest.where(tender_id: tender.id, stone_id: stone.id, round: round - 1 , customer_id: self.id, interest: 1).first.present?
    elsif type == 'sight'
      return YesNoBuyerInterest.where(tender_id: tender.id, sight_id: stone.id, round: round - 1, customer_id: self.id, interest: 1).first.present?
    end
    #forbid to place bid by default
    return false
  end
  ############

  def generate_jwt_token
    if Rails.env == "production" || Rails.env == "staging"
      service_account_email = ENV['service_account_email']
      private_key = OpenSSL::PKey::RSA.new ENV['private_key']
      now_seconds = Time.now.to_i
      payload = {:iss => ENV['service_account_email'],
                 :sub => ENV['service_account_email'],
                 :aud => "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
                 :iat => now_seconds,
                 :exp => now_seconds+(60*60), # Maximum expiration time is one hour
                 :uid => self.id.to_s}
      token = JWT.encode payload, private_key, "RS256"
      token
    end
  end

  def set_roles_to_customer
    CustomerRole.create(role_id: 1, customer_id: self.id)
    CustomerRole.create(role_id: 2, customer_id: self.id)
  end

  rails_admin do
    list do
      # field :verified, :toggle
      [:email, :first_name, :last_name, :mobile_no, :company, :last_sign_in_at, :company_address].each do |field_name|
        field field_name
      end
    end
    show do
      [:id, :email, :first_name, :last_name, :certificate, :city, :address, :phone, :phone_2,:mobile_no, :company,:company_address, :authentication_token].each do |field_name|
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
      field :is_requested
    end
  end
end

