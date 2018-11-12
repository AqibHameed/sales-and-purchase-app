module TenderState

  extend ActiveSupport::Concern
  class_methods do
    def tenders_state(state)
      if state == "active"
        active
      elsif state == "past"
        past
      elsif state == "upcoming"
        upcoming
      else
        all
      end
    end
  end
end
