Rails.application.routes.draw do
  get "static_pages/about"

  # root "tests#index"

  resources :tests do
    resources :questions, shallow: true
  end
end
