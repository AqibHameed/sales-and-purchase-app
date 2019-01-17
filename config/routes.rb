Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', :to => 'home#login'
  get '/signup', :to => 'home#registration'

  get '/calculator', :to => 'calculator#index', :ad => 'calculator'
  get "calculator/index1"
  get "calculator/get_parcels"
  get "calculator/get_prices"
  get "/verified_unverified", to: 'home#verified_unverified'
  get "/change_tender_open_time", to: 'tenders#update_time'
  get '/change_system_price', to: 'tenders#update_system_price'
  get '/can_update', to: 'tenders#round_updated'
  get '/get_timer', to: 'tenders#timer_value'
  get '/faq', to: 'home#faq'
  get '/privacy_policy', to: 'home#privacy_policy'
  get '/tos', to: 'home#tos'

  get '/chat', to: 'chats#index'
  get '/video_chat', to: 'chat_vidoes#index'

  get '/admins/sign_up', to: redirect('/')
  devise_for :admins, :controllers => {:sessions => 'sessions'}
  mount RailsAdmin::Engine => '/admins', :as => 'rails_admin'

  devise_for :customers, :controllers => {:sessions => 'sessions',:registrations => "registrations", :invitations => 'invitations'}

  resources :tenders do
    collection do
      get :history
      get :calendar
      get :calendar_data
      post :yes_or_no_winners
      get :yes_no_rounds
    end
    member do
      delete :delete_stones
      delete :delete_sights
      delete :delete_winner_details
      get :confirm_bids
      put :undo_confirmation
      get :bid
      get :send_confirmation
      post :filter
      post :temp_filter
      get :add_note
      post :save_note
      post :add_rating
      post :add_read
      get :view_past_result
      get :admin_details
      get :admin_winner_details
      post :update_stone_desc
      post :update_winner_desc
      get :show_stone
      #reports
      get :winner_list
      get :bidder_list
      get :customer_bid_list
      get :customer_bid_detail
    end
  end

  resources :winners do
    collection do
      get :list
      get :winner
      get :bidders
      get :print
      get :download_excel
      put :save
      get :results
      get :approved_list
    end
  end

  resources :bids do
    collection do
      get :list
      get :tender_total
      get :tender_success
      get :tender_unsuccess
      get :parcel_report
    end
  end

  resources :search do
    collection do
      put :results
    end
  end

  resources :customers do
    member do
      get :shared_info
    end
    collection do
      get :profile
      patch :update_profile
      get :change_password
      get :list_company
      patch :update_password
      get :trading
      get :demanding
      post :demanding_create
      get :search_trading
      get :transactions
      get :credit
      get :info
      get :invite
      post '/invite', to: 'customers#save_invite'
      #get :scores
      get :buyer_scores
      get :seller_scores
      post :shared
      get :transaction_list
      get :demanding_search, path: 'search'
      get :search_demand_list
      get :demand_from_search
      get :approve_access
      post :approve
      post :remove
      get :polished_demand
      post '/polished_demand', to: 'customers#create_polished_demand'
    end
    member do
      get :add_company
      get :block_unblock_user
      post :create_sub_company
      delete :remove_demand
    end
  end

  resources :companies do
    collection do
      get :list_company
      post :company_limits
      get :check_company
      get :country_company_list
      get :secure_center
      get :download_secure_center
    end
  end

  resources :companies_groups do
    collection do
      get :delete_group
    end
  end

  resources :stones do
    resources :bids do
      collection do
        get :place_new
      end
    end
  end

  resources :sights do
    resources :bids do
      collection do
        get :place_new
      end
    end
  end

  resources :suppliers do
    member do
      get :single_parcel
      get :demand
    end
    collection do
      get :trading
      post :parcels
      get :transactions
      get :profile
      get :credit
      get :credit_request
      get :confirm_request
      get :show_request
      get :accept_request
      delete :decline_request
      patch :update_request
      post :save_credit_request
      get :add_fields
      get :credit_given_list
      get :single_parcel_form
      get :add_demand_list
      post :upload_demand_list
      get :add_company_list
      post :upload_company_list
      get :important
      post '/add_limit', to: 'suppliers#save_add_limit'
      get :add_limit
    end
  end
  resources :messages
  resources :trading_parcels do
    collection do
      post :check_for_sale
      get :historical_polished
      get :direct_sell
      get :remove_direct_parcel
      post '/direct_sell', to: 'trading_parcels#save_direct_sell'
    end
    member do
      get :message
      post :message_create
      get :related_seller
      get :parcel_history
      post :accept_transaction
      get :size_info
    end
  end
  resources :transactions do
    collection do
      get :customer
      get :invite
      post :invite_send
      post :payment
    end
    member do
      get :confirm
      get :reject
      get :cancel
      patch :reject_reason
    end
  end
  resources :proposals do
    member do
      put :accept
      put :reject
      put :paid
      put :buyer_accept
      put :buyer_reject
    end
  end
  resources :brokers, only: [:index] do
    collection do
      get :send_request
      get :requests
      get :accept
      get :reject
      get :remove
      get :shared_parcels
      get :dashboard
      get :invite
      post :send_invite
    end
    member do
      get :demand
    end
  end

  resources :sub_companies, only: [:index] do
    collection do
      get  :invite
      post :send_invite
      get  :set_limit
      get  :save_limit
      delete :remove_customer_limit
    end
    member do
      get :show_all_customers
    end
  end

  namespace :api do
    namespace :v1 do
      devise_scope :customer do
        post :log_in, to: 'sessions#create'
        get :get_customer, to: 'sessions#customer_by_token'
        delete :log_out, to: 'sessions#destroy'
        post :signup, to: 'registrations#create'
        post :company_limits, to: 'companies#list_company'
        post :forgot_password, to: "passwords#create"
      end
      get '/tender_parcel', to: 'tenders#tender_parcel'
      post '/stone_parcel', to: 'tenders#stone_parcel'
      get '/find_active_parcels', to: 'tenders#find_active_parcels'
      get '/tender_winners', to: 'tenders#tender_winners'
      get '/bid_history', to: 'stones#last_3_bids'
      post '/attachment', to: 'api#email_attachment'
      get '/old_tenders', to: 'tenders#old_tenders'
      get '/old_upcoming', to: 'tenders#old_upcoming'
      get '/old_tender_parcel', to: 'tenders#old_tender_parcel'
      get '/customer_list', to: 'api#customer_list'
      get '/company_list', to: 'api#company_list'
      put '/update_chat_id', to: 'api#update_chat_id'
      get '/blocked_customers', to: 'companies#blocked_customers'
      post '/reset_limits', to: 'companies#reset_limits'
      get '/check_company', to: 'companies#check_company'
      get '/countries_list', to: 'companies#country_list'
      get '/companies_list', to: 'companies#companies_list'
      post '/invite', to: 'companies#invite'
      post '/feedback', to: 'companies#send_feedback'
      get '/history', to: 'companies#history'
      get '/seller_companies', to: 'companies#seller_companies'
      get '/secure_center', to: 'companies#live_monitoring'
      get '/download_secure_center', to: 'companies#download_secure_center'
      resources :tenders do
        collection do
          get :upcoming
          get :closed
        end
      end
      resources :tender_notifications do
        collection do
          get :notifications
          get :clear
        end
      end
      resources :companies do
        collection do
          post :send_security_data_request
          post :accept_secuirty_data_request
          post :reject_secuirty_data_request
        end
      end
      resources :stones, path: '/parcels' do
        collection do
          post :upload
        end
      end
      resources :transactions do
        collection do
          post :make_payment
          post :confirm
          post :seller_confirm
          post :reject
        end
      end
      resources :limits do
        collection do
          post :add_limits
          post :add_overdue_limit
          post :block
          post :unblock
          get  :credit_limit_list
          post :add_star
        end
      end
      resources :messages do
        collection do
          get :limit_messages
          get :unread_count
        end
      end
      resources :proposals do
        member do
          get :accept_and_decline
          post :negotiate
        end
      end
      resources :trading_parcels do
        collection do
          post :direct_sell
          get :available_trading_parcels
        end
        member do
          post :request_limit_increase
          get :accept_limit_increase
          get :reject_limit_increase
        end
      end
      resources :companies_groups
      get '/filter_data', to: 'api#filter_data'
      post '/device_token', to: 'api#device_token'
      post '/supplier_notification', to: 'api#supplier_notification'
      get '/app_versions', to: 'api#app_versions'
      get '/suppliers', to: 'api#get_suppliers'

      resources :demands, only: [:create, :index, :destroy] do
        collection do
          get :demand_suppliers
          get :parcels_list
          get :demand_description
          get :live_demands
        end
      end

      resources :brokers, only: [:create, :index, :destroy] do
        collection do
          get :assigned_parcels
          get :demanding_companies
          post :accept
          post :reject
          post :remove
          post :send_request
          get  :show_requests
          get  :show_myclients
          get  :company_record_on_the_basis_of_roles
          get  :dashboard
        end
      end

      resource :customers do
        get :transactions
        get :sales
        get :purchases
        get :feedback_rating
      end


      get '/profile', to: 'customers#profile'
      patch '/update_profile', to: 'customers#update_profile'
      post '/approve_reject', to: 'customers#approve_reject_customer_request'
      patch '/update_password', to: 'customers#update_password'
      get '/user_requests', to: 'customers#get_user_requests'
      get '/access_tiles', to: 'customers#access_tiles'
    end
  end

  resources :auctions do
    member do
      post :place_bid
      get :round_completed
    end
  end
  root :to => 'customers#trading'

  get '/change_limits' => 'suppliers#change_limits', as: 'change_credit_limit'
  get '/change_market_limit' => 'suppliers#change_market_limit', as: 'change_market_limit'
  get '/trading_history' => 'tenders#trading_history', as: 'trading_history'
  get '/polished_trading_history' => 'tenders#polished_trading_history', as: 'polished_trading_history'
  get '/change_days_limits' => 'suppliers#change_days_limits', as: 'change_days_limit'
  get '/supplier_demand_list' => 'suppliers#supplier_demand_list'
  get '/supplier_list' => 'suppliers#supplier_list'
  get '/update_chat_id',to: 'tenders#update_chat_id'
  get '/parcel_detail', to: 'trading_parcels#parcel_detail'
  get '/access_denied', to: 'customers#access_denied'
  get '/live_demands', to: 'customers#live_demands'
end
