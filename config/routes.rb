Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', :to => 'home#login'
  get '/signup', :to => 'home#registration'

  get '/calculator', :to => 'calculator#index', :ad => 'calculator'
  get "calculator/index1"
  get "calculator/get_parcels"
  get "calculator/get_prices"

  devise_for :admins, :controllers => {:sessions => 'sessions'}
  mount RailsAdmin::Engine => '/admins', :as => 'rails_admin'
  devise_for :customers, :controllers => {:sessions => 'sessions',:registrations => "registrations"}

  resources :tenders do
    collection do
      get :history
      get :calendar
      get :calendar_data

    end
    member do
      delete :delete_stones
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
    collection do
      get :profile
      patch :update_profile
      get :change_password
      get :list_company
      patch :update_password
      get :trading
      get :search_trading
      get :transactions
      get :credit
    end
    member do
      get :add_company
      get :block_unblock_user
      post :create_sub_company
    end
  end

  resources :companies do
    collection do
      get :list_company
      post :company_limits
    end
  end

  resources :stones do
    resources :bids do
      collection do
        get :place_new
      end
    end
  end

  resources :suppliers do
    collection do
      get :trading
      post :parcels
      get :transactions
      get :credit
      get :credit_given_list
    end
  end
  resources :trading_parcels
  resources :transactions do
    collection do 
      get :customer
    end
  end
  resources :proposals do
    member do
      put :accept
      put :reject
      put :paid
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
      resources :tenders do
        collection do
          get :upcoming
        end
      end
      resources :tender_notifications

      get '/filter_data', to: 'api#filter_data'
      post '/device_token', to: 'api#device_token'
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
end
