Rails.application.routes.draw do
  get "static_pages/about"

  root "tests#index"

  resources :tests
end
