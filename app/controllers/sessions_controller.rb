class SessionsController <  Devise::SessionsController

  def get_resource
    if customer = Customer.where("(email = ? OR mobile_no = ?) AND verified = ?", params[:customer][:login], params[:customer][:login], true).present?
      return :customer
    elsif Admin.where(email: params[:customer][:login]).present?
      return :admin
    end
  end

  def new
    redirect_to '/login'
  end

  def create
    customer = Customer.where("email = ? OR mobile_no = ?", params[:customer][:login], params[:customer][:login])
    admin = Admin.where(email: params[:customer][:login])
    if customer.present?
      # if customer.first.verified
        resource = warden.authenticate(auth_options)
        if resource
          set_flash_message(:notice, :signed_in) if is_flashing_format?
          sign_in(resource_name, resource)
          if resource.has_role?('Broker')
            redirect_to dashboard_brokers_path, notice: 'Signed in successfully.'
          else
            redirect_to '/', notice: 'Signed in successfully.'
          end
        else
          redirect_to login_path, notice: 'Invalid email or password'
        end
      # else
      #   redirect_to '/', notice: 'You are not verified. Please contact admin.'
      # end
    elsif admin.present?
      resource = admin.first
      if resource and resource.valid_password?(params[:customer][:password])
        sign_in(:admin, resource)
        redirect_to '/admins', notice: 'Signed in successfully.' 
      else
        redirect_to login_path, notice: 'Invalid email or password'
      end
    else
      redirect_to login_path, notice: "Incorrect Email or Mobile no."
    end
  end
end
