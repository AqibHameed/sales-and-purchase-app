class SendNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(transaction, current_company)
    if transaction.buyer.customers.count < 1
      CustomerMailer.unregistered_users_mail_to_company(current_customer, current_company.name, transaction).deliver_later rescue logger.info "Error sending email"
    else
      CustomerMailer.mail_to_registered_users(current_customer, current_company.name, transaction).deliver_later rescue logger.info "Error sending email"
    end
    all_user_ids = transaction.buyer.customers.map {|c| c.id}.uniq
    current_company.send_notification('New Direct Sell', all_user_ids)
    transaction.set_due_date
    transaction.generate_and_add_uid
  end
end