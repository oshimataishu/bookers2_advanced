Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about' => 'homes#about',as: 'about'

  devise_for :users

  resources :users, only: [:show, :index, :edit, :update] do
    resource :relationships, only: [:create, :destroy] do
      get 'followings' => 'relationships#followings', as: "followings"
      get 'followers' => 'relationships#followers', as: "followers"
    end
  end

  resources :books, only: [:show, :index, :create, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
end
