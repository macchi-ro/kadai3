Rails.application.routes.draw do
  get 'home/about' => "homes#about", as: "about"

  root to: "homes#top"
  devise_for :users

  resources :books, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
   resources :comments, only: [:create, :destroy]
   resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:new, :edit, :index, :show, :update, :destroy] do
  resource :relationships, only: [:create, :destroy]
   get 'followers' => 'relationships#followers', as: 'followers'
   get 'followeds' => 'relationships#followeds', as: 'followeds'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
