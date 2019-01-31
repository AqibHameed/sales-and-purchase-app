class UpdateSellerPercentileRankJob < ActiveJob::Base
  queue_as :default

  def perform_now
    SellerScore.update_seller_percentile_rank
  end
end
