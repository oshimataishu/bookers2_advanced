Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about' => 'homes#about',as: 'about'

  devise_for :users

  resources :users, only: [:show, :index, :edit, :update]

  resources :books, only: [:show, :index, :create, :edit, :update, :destroy]
end
