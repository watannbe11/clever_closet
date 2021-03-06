Rails.application.routes.draw do
  mount Notifications::Engine => "/notifications"
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => "/cable"

  get '/tagged', to: "items#tagged", as: :tagged
  

  resources :users, only: [:show, :index, :edit, :update, ] do
    post 'request_friendship'
    post 'accept_request'
    post 'decline_request'
    post 'remove_friend'
    get 'link'
    get 'notification'
    resources :donations, only: [:index]
    resources :looks, only: [:new, :create]
  end

  resources :items do
    resources :donations, only: [:new, :create]
    get 'borrow', to: 'chat_rooms#borrow', as: :borrow
  end
  # resources :items, only: [:index]

  resources :chat_rooms, only: [:index, :show, :new, :create] do
    resources :messages, only: [:create]
  end

  resources :looks, except:[:new, :create] do
    member do
      put "upvote", to: "looks#upvote", as: :upvote
    end
  end

end
