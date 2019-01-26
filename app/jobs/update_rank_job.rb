class UpdateRankJob < ActiveJob::Base
  queue_as :default

  def perform_now
    Rank.update_rank
  end
end
