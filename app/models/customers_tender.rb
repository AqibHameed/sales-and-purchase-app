class CustomersTender < ActiveRecord::Base
  
  belongs_to :customer
  belongs_to :tender

#  after_create :send_new_tender_mail

  def send_new_tender_mail
    TenderMailer.new_tender_mail(self.tender, self.customer).deliver
  end

  def self.send_confirmation_mail(tender, customer, bid)
     #if self.confirmed_changed?
      TenderMailer.confirmation_mail(tender, customer, bid).deliver
     #end  
  end
    
  rails_admin do
  	list do
  		[:customer, :tender, :confirmed].each do |field_name|
        field field_name
  	  end
  	  field :created_at do
  	     strftime_format "%Y-%m-%d"
      end
    end
  end  
end

