Rails.application.routes.draw do
  root "tests#index"

  get "sessions/new"
  get "users/new"
  get "static_pages/about"

  get :signup, to: "users#new"
  get :login, to: "sessions#new"
  delete :logout, to: "sessions#destroy"

  resources :users, only: :create
  resources :sessions, only: :create

  resources :tests do
    member do
      post :start
    end

    resources :questions, shallow: true, except: :index do
      resources :answers, shallow: true, except: :index
    end
  end

  # GET /test_passages/101/result
  resources :test_passages, only: %i[show update] do
    member do
      get :result
    end
  end
end
