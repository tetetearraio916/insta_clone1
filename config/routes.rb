Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #ルートurlは投稿一覧に設定
  root to: 'posts#index'

  #いいね関連
  resources :likes, only: [:create, :destroy]

  #投稿関連
  #shallowを使う事でurlの省略
  resources :posts, shallow: true do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  #ユーザー関連
  resources :users

  #通知機能
  resources :notifications, only: [] do
    patch :read, on: :member
  end

  #ログイン関連
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
