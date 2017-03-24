Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :movies do
    member do
      post :favorite
      post :dislike
    end

    resources :reviews
  end

  namespace :account do
    resources :movies
    resources :reviews
  end

  root 'movies#index'
end
