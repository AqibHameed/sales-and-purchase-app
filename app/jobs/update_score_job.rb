class UpdateScoreJob < ActiveJob::Base
  queue_as :default

  def perform_now
    ApplicationHelper.update_scores
  end
end
