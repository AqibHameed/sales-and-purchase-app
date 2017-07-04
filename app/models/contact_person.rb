class ContactPerson < ActiveRecord::Base
  attr_accessible :name, :designation, :company_id, :telephone, :mobile, :passport_no, :pio_card
  DESIGNATION = ["Manager", "Director", "Sub_User"]

  belongs_to :company

  validates  :name, :designation, :company_id, presence: :true
  validates_uniqueness_of :name

  rails_admin do

   
    edit do
        [:name, :telephone, :mobile, :passport_no, :pio_card].each do |field_name|
      	  field field_name
     		 end
     		 field :company 
     	field :designation, :enum do
        enum do 
          DESIGNATION
        end
      end
      # field :passport_no do
      # 	partial :select_designation
      # end   
          
    end
  end  
end
