class TempStone < ApplicationRecord
  attr_accessible :carat, :description, :lot_no, :no_of_stones, :tender_id


  validates_presence_of :lot_no, :tender_id

  validates_numericality_of :no_of_stones,:carat, :allow_blank => true


  belongs_to :tender

  def key
    self.description + '#' + self.carat.to_s
  end


  rails_admin do
    list do
      [:tender,:lot_no, :description, :no_of_stones, :carat].each do |field_name|
        field field_name
      end
    end
    edit do
      field :tender
      [:deec_no, :lot_no, :description, :no_of_stones, :carat].each do |field_name|
        field field_name
      end
    end
  end

end
