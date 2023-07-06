Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#top"                              # Topページを設定
  devise_for :users
  get "/home/about" => "homes#about", as: "about"   # aboutをルートに追加

  get "search" => "searches#search" #検索

  resources :books, only: [:new, :index,:show,:edit,:create,:destroy,:update] do
    # いいね機能のルーティングを設定
    resource :favorites, only: [:create, :destroy]
    # コメント機能のルーティングを設定
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
  	get "followings" => "relationships#followings", as: "followings"
  	get "followers" => "relationships#followers", as: "followers"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end