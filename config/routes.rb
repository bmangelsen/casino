Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }

  devise_scope :user do
    get "users/game_history", to: "users/registrations#game_history", as: "game_history"
    get "users/admin_view", to: "users/registrations#admin_view", as: "admin_view"
  end

  get '/games/join_game', to: 'games#join_game', as: 'join_game'

  resources :players, only: [:new, :create]
  resources :games, only: [:create, :index, :show]
  resources :decks, only: [:create, :update]
  resources :hands, only: [:update]

  get '/game_type/:id/activate', to: 'game_type#activate', as: 'activate'
  get '/game_type/:id/rules', to: 'game_type#rules', as: 'rules'
  get '/game_type/:id/deactivate', to: 'game_type#deactivate', as: 'deactivate'
  post '/hands/create_deck', to: 'hands#create_deck', as: 'create_deck'

  root "games#index"
end
