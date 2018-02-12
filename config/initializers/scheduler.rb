require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '5 0 * * *' do
  Transaction.send_overdue_email
end

scheduler.cron '* * * * *' do
  Tender.update_round_prices
end

scheduler.every '5m' do
  Demand.update_demands_block_unblock
end