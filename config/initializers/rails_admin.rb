# RailsAdmin config file. Generated on May 29, 2013 15:28
# See github.com/sferik/rails_admin for more informations

require Rails.root.join('lib', 'rails_admin_destroy_all_stones.rb')

RailsAdmin.config do |config|
  config.authorize_with :cancan
  config.parent_controller = 'AdminApplicationController'
  # config.audit_with :paper_trail, 'Customer'
  # config.audit_with :paper_trail, 'Admin'

  config.audit_with :history, 'Admin'
  config.audit_with :paper_trail, 'Customer', 'PaperTrail::Version'

  PAPER_TRAIL_AUDIT_MODEL = ['Transaction', 'Company', 'TradingParcel', 'PartialPayment', 'SecureCenter', 'DaysLimit', 'Proposal', 'CreditLimit']
  config.actions do
    history_index do
      only PAPER_TRAIL_AUDIT_MODEL
    end
    history_show do
      only PAPER_TRAIL_AUDIT_MODEL
    end
  end


  #Register custom action to rails admin
  module RailsAdmin
    module Config
      module Actions
        class DestroyAllStones < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
      end
    end
  end


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Dialuck', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_admin } # auto-generated

  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index                         # mandatory
    new
    export
    bulk_delete
    # member actions
    show
    edit
    delete
    # show_in_app
    # custom action
    toggle
#    destroy_all_stones do
#      visible do
#        bindings[:abstract_model].model.to_s == "Tender"
#      end
#    end
  end

  # If you want to track changes on your models:
  # config.audit_with :history, 'Admin'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'Admin'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  config.excluded_models = ['Version', 'TempStone']

  # Include specific models (exclude the others):
  # config.included_models = []

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:
end