class SessionsController <  Devise::SessionsController

  def get_resource
    if Customer.find_by_email_and_status(params[resource_name][:email],true).present?
      return :customer
    elsif Admin.find_by_email(params[resource_name][:email]).present?
      return :admin
    end
  end

  def new
    redirect_to '/login'
  end

  def create
    scope = get_resource
    resource = warden.authenticate!(:scope => scope )
    if resource.sign_in_count == 1
      session[:show_popup] = true
    else
      session[:show_popup] = false
    end
    respond_to do |format|
      format.html { redirect_to after_sign_in_path_for(resource) }
      format.js { render :js => "window.location.href = '#{after_sign_in_path_for(resource)}'", turbolinks: false}      
    end

  end

end