Dialuck::Application.routes.draw do

  

  match '/login', :to => 'home#login'
  
  match '/calculator', :to => 'calculator#index', :ad => 'calculator'
  get "calculator/index1"
  get "calculator/get_parcels"
  get "calculator/get_prices"

  devise_for :admins, :controllers => {:sessions => 'sessions'}
  mount RailsAdmin::Engine => '/admins', :as => 'rails_admin'
  devise_for :customers, :controllers => {:sessions => 'sessions'}

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
      put :update_profile
      get :change_password
      put :update_password
    end
  end

  resources :stones do
    resources :bids do
      collection do
        get :place_new
      end
    end
  end

  root :to => 'tenders#index'

end

