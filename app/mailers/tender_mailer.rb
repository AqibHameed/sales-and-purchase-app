class TenderMailer < ApplicationMailer
  default from: "SafeTrade Team <contact@safetrade.ai>"

  def new_tender_mail(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[SafeTrade] New Tender #{@tender.name} Assigned" )
  end

  def confirmation_mail(tender, customer, bid)
    @tender, @customer, @bid = tender, customer, bid

    mail(:to => @customer.email, :subject => '[SafeTrade] Bid confirmation Mail', :cc => "info@idtonline.co" )
  end

  def winning_mail(customer, stone)
    @customer, @stone = customer, stone
    mail(:to => @customer.email, :subject => '[SafeTrade] Congratulations! You have won the bid.')
  end

  def send_tender_open_notification(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[SafeTrade] Tender #{@tender.name} Opens")
  end


  def send_winner_list_uploaded_mail(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[SafeTrade] Winner list updated for #{@tender.name} Tender")
  end

  def send_notify_winning_buyers_mail(tender, customer)
    @tender, @customer = tender, customer
    mail(:to => @customer.email, :subject => "[SafeTrade] Notify Winning buyers #{@tender.name} Tender")
  end

  def send_tender_close_notification(tender, admin)
    @tender, @admin = tender, admin
    mail(:to => @admin.email, :subject => "[SafeTrade] Tender #{@tender.name} closing today")
  end

  def account_creation_mail(customer)
    @customer = customer
    mail(:to => @customer.email, :subject => '[SafeTrade] New Account Created')
  end

  def shared_info_email(current_customer, customer_id)
    @shared_by_customer = current_customer
    @shared_to_customer = Customer.find(customer_id)
    mail(:to => @shared_to_customer.email, :subject => "[SafeTrade] Information Shared by {@shared_by_customer.name}" )
  end

  def send_attachment_to_admin(attachment, customer)
    @customer = customer
    @attachment = attachment
    mail(:to => 'info@idtonline.co', :subject => '[SafeTrade] New Attachment' )
  end

  def parcel_up_email(parcel, emails)
    @emails = emails
    @parcel = parcel
    mail(:to => emails, :subject => '[SafeTrade] Parcel is up for sale' )
  end

  def parcel_won_email(customer, parcel)
    @customer = customer
    @parcel = parcel
    mail(:to => @customer.email, :subject => '[SafeTrade] You won the parcel' )
  end

  def send_overdue_transaction_mail(transaction)
    @transaction = transaction
    @buyer = transaction.buyer
    @supplier = transaction.supplier
    mail(:to => @buyer.email, :subject => '[SafeTrade] Payment is due' )
  end

  def payment_received_email(transaction, payment)
    @transaction = transaction
    @payment = payment
    mail(:to => @transaction.buyer.email, :subject => '[SafeTrade] Payment is received' )
  end

  def buyer_reject_transaction(transaction)
    @transaction = transaction
    mail(:to => @transaction.trading_parcel.customer.email, :subject => '[SafeTrade] Buyer rejected your direct sell.' )
  end
end