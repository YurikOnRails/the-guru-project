Rails.application.routes.draw do
  resources :answers
  get "static_pages/about"

  resources :tests do
    resources :questions, except: :index, shallow: true
  end
end
