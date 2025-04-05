Rails.application.routes.draw do
  devise_for :users
  root "tests#index"

  # Статическая страница О нас
  get "static_pages/about"

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

  namespace :admin do
    resources :tests
  end

end
