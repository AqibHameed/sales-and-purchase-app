class PartialPayment < ApplicationRecord
validate :check_amount
has_paper_trail
 def check_amount
    transaction = Transaction.find(self.transaction_id)
    if transaction.remaining_amount < amount
      errors[:base] << "Amount should be less than the total amount to be paid"
    end
 end

  rails_admin do
    configure :versions do
      label "Versions"
    end
  end

end
