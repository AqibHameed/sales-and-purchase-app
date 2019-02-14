namespace :update_score do
  task :update_score_job => :environment do
    UpdateScoreJob.perform_now
  end
end
