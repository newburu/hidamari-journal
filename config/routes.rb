Rails.application.routes.draw do
  devise_for :users

  resources :annual_themes

  root to: "annual_themes#index"
end
