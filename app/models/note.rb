class Note < ApplicationRecord

  attr_accessible :customer_id, :key, :note, :tender_id, :stone_id, :deec_no

  belongs_to :customer
  belongs_to :tender
  belongs_to :stone

  before_save :update_deec_no, :if => Proc.new { |m| !m.stone_id.blank? && m.deec_no.blank?}

  def update_deec_no
    stone = Stone.find_by_id(self.stone_id)
    self.deec_no = stone.try(:deec_no)
  end

  rails_admin do
  	list do
      configure :description do
        pretty_value do
          data = bindings[:object].try(:key).split('#').first
          data
        end
      end
      configure :carat do
        pretty_value do
          data = bindings[:object].try(:key).split('#').last
          data
        end
      end
  		[:customer, :tender, :description, :carat, :deec_no, :note].each do |field_name|
        field field_name
  	  end
  	  field :created_at do
  	     strftime_format "%Y-%m-%d"
      end
    end
    edit do
      [:customer, :tender, :key, :note, :stone].each do |field_name|
        field field_name
      end
    end
  end
end
