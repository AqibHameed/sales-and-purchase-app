class Winner < ApplicationRecord

  attr_accessible :stone_id, :customer_id, :bid_id, :tender_id, :sight_id

  validates_uniqueness_of :bid_id, :scope => [:stone_id,:customer_id]

  belongs_to :stone
  belongs_to :bid
  belongs_to :customer
  belongs_to :tender
  #  after_create :send_winning_mail
  def send_winning_mail
    TenderMailer.winning_mail(self.customer, self.stone).deliver rescue logger.info "Error sending email"
  end

  rails_admin do
    label "System Winner"
    label_plural "System Winners"
    list do
      [:tender, :customer, :bid, :stone].each do |field_name|
        field field_name
      end
      field :created_at do
        strftime_format "%Y-%m-%d"
      end
    end
  end
end

