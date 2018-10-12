class EmailTemplate < ApplicationRecord
  rails_admin do
    edit do
      field :before_here
      field :after_here
    end
  end
end
