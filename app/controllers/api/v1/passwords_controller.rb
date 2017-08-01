module Api
  module V1
    class PasswordsController < Devise::PasswordsController
      skip_before_action :verify_authenticity_token
      respond_to :json

      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)
        yield resource if block_given?
        if successfully_sent?(resource)
          render :json => {:success => true, message: 'You will receive an email with instructions about how to reset your password in a few minutes'}, :status => 200
        else
          render :json => {:success => false, message: 'There is no account with this email.' }, :status => 404
        end
      end
    end
  end
end