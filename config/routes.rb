NewBlockCity::Application.routes.draw do
  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  namespace :api do
    resources :worlds do
      resources :regions
    end

    resources :users, only: [] do
      member do
        get :photo
      end
    end

    resources :neighborhoods, only: :index do
      member do
        get :neighbors
      end
    end

    resources :blocks
    resources :panda_videos do
      collection do
        post :callback
      end
    end
  end

  resource :admin, controller: :admin, only: :show do
    member do
      get :test
    end
  end

  namespace :admin do
    resources :blocks
    resources :panda_videos
  end

  namespace :client do
    resources :blocks, only: :create
  end

  # For CORS (Cross Origin Resource Sharing)
  match '/client/blocks',
    :controller => 'client/blocks',
    :action => 'options',
    :constraints => {:method => 'OPTIONS'}

  resources :partials, only: :show

  # Explicitly mount Jasminerice above global match rule to prevent trumping of jasmine
  mount Jasminerice::Engine => "/jasmine" if Rails.env.development? || Rails.env.test?
  match '/' => 'spine#index'
  match '/neighborhoods/(*other)' => 'spine#index'
  match '/regions/(*other)' => 'spine#index'
end
