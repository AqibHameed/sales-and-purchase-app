class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :customers_tenders
  has_many :tenders, :through => :customers_tenders
  has_many :bids
  has_many :winners
  has_many :notes

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name,
                  :city, :address ,:postal_code,
                  :phone, :status, :tender_ids,
                  :phone_2,:mobile_no, :company,:company_address

  # attr_accessible :title, :body
  validates :phone,
            :format => {:with => /^\d{10}$/},
            :unless => proc{|obj| obj.phone.blank?} , :reduce => true

  validates :phone_2,
            :format => {:with => /^\d{10}$/},
            :unless => proc{|obj| obj.phone_2.blank?} , :reduce => true

  validates :mobile_no,
            :format => {:with => /^\d{10}$/},
            :unless => proc{|obj| obj.mobile_no.blank?} , :reduce => true

  validates :email,
            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
            :presence => true, :reduce => true ,
            :on => :create

  validates :city,:company,:company_address , :first_name, :last_name,
            :presence => true , :reduce => true

  after_create :send_account_creation_mail
  default_scope { order("first_name asc, last_name asc") }
  
  def name
    "#{first_name} #{last_name}"
  end

  def tender_history
    self.tenders.where(:id => self.bids.map(&:tender_id))
  end
  
  def send_account_creation_mail
    
    TenderMailer.account_creation_mail(self).deliver  rescue logger.info "Error sending email"
    
  end
  

  rails_admin do
    list do
      [:email, :first_name, :last_name, :city, :company, :company_address].each do |field_name|
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

