class Version < ApplicationRecord
  rails_admin do
    list do
      # field :verified, :toggle
      [:id, :item_type, :item_id, :event, :whodunnit, :ip].each do |field_name|
        field field_name
      end
    end
    show do
      [:id, :item_type, :item_id, :event, :whodunnit, :ip].each do |field_name|
        field field_name
      end
    end
    edit do
      field :item_type
      field :item_id
      field :event
      field :whodunnit
      field :ip
    end
  end
end

