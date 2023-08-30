Rails.application.routes.draw do
  
   devise_for :users,
              controllers: {
                  sessions: 'users/sessions',
                  registrations: 'users/registrations',
                  confirmations: 'users/confirmations'
                }
    get '/member-data', to: 'members#show'
    post 'api/kyc', to: 'kyc#create'

    devise_scope :user do
      get '/users/sessions/kyc_status', to: 'users/sessions#kyc_status', as: 'user_kyc_status'
    end
                
                 
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
      
    end

    resources :transactions, only: [:index]

  
    resources :portfolio_items, only: [:index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
