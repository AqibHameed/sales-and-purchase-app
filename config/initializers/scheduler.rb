require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '5 0 * * *' do
  Transaction.send_overdue_email
end

scheduler.cron '* * * * *' do
  puts '======PRICE SECHEDULER 1========'
  Tender.update_round_prices
end

scheduler.every '1m' do
  puts 'Hello... Rufus'
  puts '======PRICE SECHEDULER 2========'
  Tender.update_round_prices
end
