Rails.application.routes.draw do
  resources :answers
  get "static_pages/about"

  resources :tests do
    resources :questions, shallow: true, except: :index do
      resources :answers, shallow: true
    end
  end
end
