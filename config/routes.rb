Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'posts#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :likes, only: [:create, :destroy]

  # shallowを使う事でurlの親のidを省略
  resources :posts, shallow: true do
    collection do
      get :search
    end
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  get 'search', to: 'posts#search'

  resources :users do
    member do
      get :follow, :followed
    end
  end

  resources :relationships, only: [:create, :destroy]

  namespace :mypage do
    # 今回はurlにidが不要なためresourcesではなく、resourceを使う
    resource :account, only: [:edit, :update]
    # プロフィールの通知一覧
    resources :notifications, only: :index
    # notificationの通知設定
    resource :notification_setting, only: [:edit, :update]
  end

  # ヘッダーの通知一覧
  scope module: :mypage do
    resources :notifications, only: [] do
      patch :read, on: :member
    end
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
