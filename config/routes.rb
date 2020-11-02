Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'posts#index'
  #shallowを使う事でurlの省略
  resources :posts, shallow: true do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
