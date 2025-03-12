Rails.application.routes.draw do

  # TEMP, to stop working with views
  # ? is this temporary...? how does api-only app handle?
  defaults format: :json do

    # unauthn'd restaurants endpoint
    resources :restaurants, only: [:index, :show]

    # user id is implicitly present from auth jwt, so namespace instead of resource, which would accept/require it in path
    namespace :customers do
      resources :orders, only: [:index, :show, :create, :update] do
        resources :order_statuses, only: [:index, :create], controller: '/users_shared/order_statuses'
      end
    end

    # user id is implicitly present from auth jwt, so namespace instead of resource, which would accept/require it in path
    namespace :owners do
      # index will currently only have one entry
      resources :restaurants, only: [:index, :show, :update] do
        resources :meals, only: [:index, :show, :create, :update]
        resources :orders, only: [:index, :show] do
          resources :order_statuses, only: [:index, :create], controller: '/users_shared/order_statuses'
        end
      end
    end

  end

  # use alternate controller to pick up devise/api hacks
  # also, default to json responses to disable devise redirects after 'sign in'
  devise_for :users,
    controllers: {
      sessions: 'user_sessions',
      registrations: 'user_registrations'
    },
    defaults: { format: :json }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # root to: "home#index"
end
