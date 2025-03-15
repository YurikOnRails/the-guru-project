Rails.application.routes.draw do
  get "static_pages/about"

  resources :tests do
    resources :questions, shallow: true
  end
end
