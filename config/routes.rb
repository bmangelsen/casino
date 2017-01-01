Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  devise_scope :user do
    get "users/game_history", to: "users/registrations#game_history", as: "game_history"
  end

  resources :players, only: [:new, :create]
  resources :games, only: [:create, :index, :show]
  resources :decks, only: [:create, :update]
  resources :hands, only: [:update]

  post '/display_cards', to: 'hands#cards', as: 'display_cards'

  post '/hands/create_deck', to: 'hands#create_deck', as: 'create_deck'

  root "games#index"
end
