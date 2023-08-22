Rails.application.routes.draw do
  
   devise_for :users,
              controllers: {
                  sessions: 'users/sessions',
                  registrations: 'users/registrations',
                  confirmations: 'users/confirmations'
                }
    get '/member-data', to: 'members#show'
    post 'api/kyc', to: 'kyc#create'

    #devise_for :admins, path: 'admin'
    namespace :admin do
      resources :kyc, only: [:index] do
        member do
          post :approve
          post :reject
        end
      end
    end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
