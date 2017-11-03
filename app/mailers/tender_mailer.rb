class TenderMailer < ApplicationMailer
  default from: "Dialuck Admin <admin@dialuck.net>"
  def new_tender_mail(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[Dialuck] New Tender #{@tender.name} Assigned" )
  end

  def confirmation_mail(tender, customer, bid)
    @tender, @customer, @bid = tender, customer, bid

    mail(:to => @customer.email, :subject => '[Dialuck] Bid confirmation Mail', :cc => "info@idtonline.co" )
  end

  def winning_mail(customer, stone)
    @customer, @stone = customer, stone
    mail(:to => @customer.email, :subject => '[Dialuck] Congratulations! You have won the bid.')
  end

  def send_tender_open_notification(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[Dialuck] Tender #{@tender.name} Opens")
  end


  def send_winner_list_uploaded_mail(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[Dialuck] Winner list updated for #{@tender.name} Tender")
  end

  def send_notify_winning_buyers_mail(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[Dialuck] Notify Winning buyers #{@tender.name} Tender")
  end  

  def send_tender_close_notification(tender, admin)
    @tender, @admin = tender, admin
    mail(:to => @admin.email, :subject => "[Dialuck] Tender #{@tender.name} closing today")
  end

  def account_creation_mail(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[Dialuck] New Account Created' )
  end

  def shared_info_email(current_customer, customer_id)
    @shared_by_customer = current_customer
    @shared_to_customer = Customer.find(customer_id)
    mail(:to => @shared_to_customer.email, :subject => "[Dialuck] Information Shared by {@shared_by_customer.name}" )
  end

end