class Review < ApplicationRecord
  belongs_to :customer
  belongs_to :company
  after_save :update_ranks


  def update_ranks
    UpdateRankJob.perform_now
  end
end
