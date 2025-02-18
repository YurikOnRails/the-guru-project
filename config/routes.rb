Rails.application.routes.draw do
  get "static_pages/about"

  root "tests#index"

  resources :tests

  get "/tests/:category/:title", to: "tests#search", level: 2
end
