Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  resources :players, only: [:new, :create]
  resources :games, only: [:create, :index, :show]
  resources :decks, only: [:create, :update]
  resources :hands, only: [:update]

  root "games#index"
end
