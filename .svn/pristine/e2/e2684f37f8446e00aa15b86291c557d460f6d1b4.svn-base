require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminDestroyAllStones
end

module RailsAdmin
  module Config
    module Actions
      class DestroyAllStones < RailsAdmin::Config::Actions::Base
        # There are several options that you can set here.
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          [:get, :delete]
        end



        register_instance_option :controller do

          Proc.new do

            if request.get? # DELETE

              respond_to do |format|
                format.html { render @action.template_name }
                format.js { render @action.template_name, :layout => false }
              end

            elsif request.delete?


              @object.stones.destroy_all

              flash[:success] = "Successfully deleted stone details for #{@model_config.label}"

              redirect_to back_or_index
            end
          end
        end
      end
    end
  end
end
#- See more at: http://fernandomarcelo.com/2012/05/rails-admin-creating-a-custom-action/#sthash.tHleaz4i.dpuf

