class InvitationsController < Devise::InvitationsController
  
  def after_invite_path_for(resource)
    root_path
  end
end