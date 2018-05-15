Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/dashboard', to: 'dashboard#show'
  get '/activate', to: 'activate#index'

  namespace :api do
    namespace :v1 do
      resources :games, only: [:create, :show] do
        post "/shots", to: "games/shots#create"
      end
    end
    namespace :v2 do
      resources :games, only: [:show] do
        post "/shots", to: "games/shots#create"
      end
    end
  end
end
