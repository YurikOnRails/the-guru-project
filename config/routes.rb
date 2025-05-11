Rails.application.routes.draw do
  devise_for :users, path: :gurus, path_names: { sign_in: :login, sign_out: :logout, sign_up: :signup }, controllers: { sessions: "users/sessions", registrations: "users/registrations", confirmations: "users/confirmations" }
  root "tests#index"

  # Статическая страница О нас
  get "static_pages/about"

  resources :tests, only: [ :index, :show ] do
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

    resources :gists, only: :create
  end

  namespace :admin do
    resources :tests do
      patch :update_inline, on: :member

      resources :questions, except: :index, shallow: true do
        resources :answers, except: :index, shallow: true
      end
    end

    resources :gists, only: :index
  end

  # Маршруты для формы обратной связи
  resources :feedbacks, only: [ :new, :create ]
end
