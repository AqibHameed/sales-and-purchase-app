class SecureCenter < ApplicationRecord
  has_paper_trail
  def supplier_connected
    supplier_paid
  end
end
