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

  get '/tables/join_table', to: 'tables#join_table', as: 'join_table'
  get '/tables/leave_table', to: 'tables#leave_table', as: 'leave_table'
  get '/tables/waiting/:id', to: 'tables#waiting', as: 'waiting'

  resources :players, only: [:new, :create]
  resources :games, only: [:create, :index, :show]
  resources :decks, only: [:create, :update]
  resources :hands, only: [:update]
  resources :tables, only: [:destroy]

  get '/game_type/:id/rules', to: 'game_type#rules', as: 'rules'
  get '/game_type/:id/activate', to: 'game_type#activate', as: 'activate'
  get '/game_type/:id/deactivate', to: 'game_type#deactivate', as: 'deactivate'

  root "games#index"
end
