require "#{Rails.root}/app/models/concerns/live_monitor.rb"
namespace :update_secure_center_record do
  include LiveMonitor
  task :update => :environment do
    SecureCenter.all.each do |secure_center|
      buyer = Company.find_by(id: secure_center.buyer_id)
      seller = Company.find_by(id: secure_center.seller_id)
      create_or_update_secure_center(secure_center, buyer, seller)
    end
  end
end