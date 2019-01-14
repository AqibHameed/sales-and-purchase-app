namespace :direct_sell do
  task :confirmation => :environment do
    paid_transactions = Transaction.where('buyer_confirmed=? AND created_at<?', false, 7.days.ago)
    paid_transactions.update(buyer_confirmed: true)
  end
end