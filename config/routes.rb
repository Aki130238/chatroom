Rails.application.routes.draw do
  root :to => 'users#index'
  resources :sessions, only: [:new, :create, :destroy]
  resources :rooms do
    resources :messages
    # member do
    #   post 'join_user'
    # end
  end

  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
