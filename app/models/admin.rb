class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :name
    # attr_accessible :title, :body
  before_validation :save_roles

  def name
    "Admin"
  end

  rails_admin do
    list do
		  [:name, :email, :roles].each do |field_name|
		    field field_name
		  end
    end
    show do
		  [:name, :email].each do |field_name|
		    field field_name
		  end
    end
    edit do
      field :name
		  field :email
		  field :password
		  field :password_confirmation do
		      help 'Length of 8-128.'
		  end
       field :roles do
        partial :roles
      end
    end
  end
  def save_roles
    unless self.roles.nil?
      data = self.roles
      op = ""
      unless data.class == String
        data.keys.each do |k|
          op << k.to_s << ':' << data[k].join(',') << "|"
        end

        logger.info "-----------------------"
        logger.info op

      self.roles = op
      end
    end

  end

end

