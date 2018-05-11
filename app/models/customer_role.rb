class CustomerRole < ApplicationRecord
  belongs_to :customer
  belongs_to :role

  rails_admin do
    list do
      field :id
      field :customer do
        queryable true
        searchable [:first_name, :last_name]
      end
      field :role do
        queryable true
        searchable :name
      end
      field :created_at
      field :updated_at
    end
  end
end
