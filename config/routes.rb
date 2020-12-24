Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #ルートurlは投稿一覧に設定
  root to: 'posts#index'


  #いいね関連
  resources :likes, only: [:create, :destroy]

  #shallowを使う事でurlの親のidを省略
  resources :posts, shallow: true do
    collection do
      get :search
    end
    resources :comments, only: [:create, :edit, :update, :destroy]
  end


  resources :users do
    member do
      get :follow, :followed
    end
  end

  resources :relationships, only: [:create, :destroy]



  namespace :mypage do
    #今回はurlにidが不要なためresourcesではなく、resourceを使う
    resource :account, only: [:edit, :update]
  end


  #通知機能
  resources :notifications, only: [] do
    patch :read, on: :member
  end

  #ログイン関連
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
