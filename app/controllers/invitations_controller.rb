class InvitationsController < Devise::InvitationsController
  
  def after_invite_path_for(resource)
    trading_customers_path
  end
end