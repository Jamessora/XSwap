Rails.application.routes.draw do

 
  
   devise_for :users,
              controllers: {
                  sessions: 'users/sessions',
                  registrations: 'users/registrations',
                  confirmations: 'users/confirmations'
                }
    devise_scope :user do
          get '/users/sessions/kyc_status', to: 'users/sessions#kyc_status', as: 'user_kyc_status'
    end
                
    get '/member-data', to: 'members#show'
    post 'api/kyc', to: 'kyc#create'
   

    
    # Make sure this route exists in your routes.rb
    get '/users/confirmation', to: 'users/confirmations#show'

    

                
                 
    #devise_for :admins, path: 'admin'
    namespace :admin do
      resources :kyc, only: [:index] do
        member do
          post :approve
          post :reject
        end
      end

      post '/createTrader', to: 'admin#create_trader'
      put '/updateTrader/:id', to: 'admin#update_trader'
      get '/allTraders', to: 'admin#all_traders'
      get '/trader/:id', to: 'admin#show_trader'
      get '/allTransactions', to: 'admin#all_transactions'
     
      
    end

    namespace :api do
      post 'trades/buy', to: 'trades#buy'
      post 'trades/sell', to: 'trades#sell'
      get 'trades/calculate_pnl', to: 'trades#calculate_pnl'
      
    end

    resources :transactions, only: [:index]

  
    resources :portfolio_items, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
