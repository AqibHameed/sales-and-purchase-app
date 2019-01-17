require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 5 * * *' do
  Transaction.send_overdue_email
end

scheduler.cron '0 8 * * *' do
  Tender.update_round_prices
end

scheduler.cron '0 12 * * *' do
  Demand.update_demands_block_unblock
end

scheduler.cron '0 15 * * *' do
  PolishedDemand.update_polished_demands_block_unblock
end

scheduler.cron '0 18 * * *' do
  ApplicationHelper.update_scores
end

scheduler.cron '3 20 * * *' do
  Transaction.direct_sell_confirm
end

scheduler.cron '0 23 * * *' do
  Transaction.sell_confirm_auto
end