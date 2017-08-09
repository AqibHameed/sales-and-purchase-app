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
    customer = Customer.where(email: params[:customer][:email])
    admin = Admin.where(email: params[:customer][:email])
    if !customer.blank? 
      resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      if resource.sign_in_count == 1
        path = 'login'
      else
        path = '/'
      end
      respond_to do |format|
        format.js{ render json: path }
      end
    elsif !admin.blank? 
      scope = get_resource
      resource = warden.authenticate!(:scope => scope )
      if resource.sign_in_count == 1
        path = 'login'
      else
        path = '/admins'
      end
      respond_to do |format|
        format.js{ render json: path }
      end
    end
  end

end
