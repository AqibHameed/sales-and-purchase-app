# require 'rufus-scheduler'
#
# scheduler = Rufus::Scheduler.new
#
# scheduler.cron '5 0 * * *' do
#   Transaction.send_overdue_email
# end
#
# scheduler.cron '* * * * *' do
#   Tender.update_round_prices
# end
#
# scheduler.every '5m' do
#   Demand.update_demands_block_unblock
# end
#
# scheduler.every '5m' do
#   PolishedDemand.update_polished_demands_block_unblock
# end
#
# scheduler.cron '0 5 * * *' do
#   ApplicationHelper.update_scores
# end
#
# scheduler.cron '3 1 * * *' do
#   Transaction.direct_sell_confirm
# end
#
# scheduler.cron '0 1 * * *' do
#   Transaction.sell_confirm_auto
# end