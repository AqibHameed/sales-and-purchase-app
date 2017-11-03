class Shared < ApplicationRecord

  belongs_to :shared_to, class_name: 'Customer', foreign_key: 'shared_to_id', optional: true
  belongs_to :shared_by, class_name: 'Customer', foreign_key: 'shared_by_id', optional: true

end
