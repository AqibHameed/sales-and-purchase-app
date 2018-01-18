require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '5 0 * * *' do
  Transaction.send_overdue_email
end

scheduler.cron '* * * * *' do
  puts '======PRICE SECHEDULER========'
  Tender.update_round_prices
end


# scheduler.in '3s' do
#   puts 'Hello... Rufus'
#   Tender.send_tender_bid_email
# end
