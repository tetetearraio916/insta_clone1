Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'posts#index'

  resources :likes, only: [:create, :destroy]

  #shallowを使う事でurlの省略
  resources :posts, shallow: true do
    collection do
      get :search
    end
    resources :comments, only: [:create, :edit, :update, :destroy]
  end


  get "search", to: "posts#search"



  resources :users do
    member do
      get :follow, :followed
    end
  end

  resources :relationships, only: [:create, :destroy]



  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
