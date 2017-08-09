class Device < ApplicationRecord
  belongs_to :customer

  rails_admin do
    visible false
  end
end
