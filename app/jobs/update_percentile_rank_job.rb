class UpdatePercentileRankJob < ActiveJob::Base
  queue_as :default

  def perform_now
    BuyerScore.update_percentile_rank
  end
end
