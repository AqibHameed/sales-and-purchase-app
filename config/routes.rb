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
      post :shared
      get :transaction_list
    end
    member do
      get :add_company
      get :block_unblock_user
      post :create_sub_company
      get :check_for_sale
      delete :remove_demand
    end
  end

  resources :companies do
    collection do
      get :list_company
      post :company_limits
    end
  end

  resources :companies_groups

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
    end
  end
  resources :messages
  resources :trading_parcels do
    member do
      get :message
      post :message_create
      get :related_seller
      get :parcel_history
      get :direct_sell
      post :save_direct_sell
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
      patch :reject_reason
    end
  end
  resources :proposals do
    member do
      put :accept
      put :reject
      put :paid
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
      put '/update_chat_id', to: 'api#update_chat_id'
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
      resources :stones, path: '/parcels' do
        collection do
          post :upload
        end
      end
      get '/filter_data', to: 'api#filter_data'
      post '/device_token', to: 'api#device_token'
      post '/supplier_notification', to: 'api#supplier_notification'
      get '/suppliers', to: 'api#get_suppliers'
    end
  end

  resources :auctions do
    member do
      post :place_bid
      get :round_completed
    end
  end
  root :to => 'tenders#index'

  get '/change_limits' => 'suppliers#change_limits', as: 'change_credit_limit'
  get '/trading_history' => 'tenders#trading_history', as: 'trading_history'
  get '/change_days_limits' => 'suppliers#change_days_limits', as: 'change_days_limit'
  get '/supplier_demand_list' => 'suppliers#supplier_demand_list'
  get '/supplier_list' => 'suppliers#supplier_list'
  get '/update_chat_id',to: 'tenders#update_chat_id'
  get '/share_with_brokers', to: 'trading_parcels#share_broker'
  get '/parcel_detail', to: 'trading_parcels#parcel_detail'
end
