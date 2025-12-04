Rails.application.routes.draw do
  get "mandala_items/edit"
  get "mandala_items/update"
  devise_for :users

  resources :annual_themes do
    member do
      get :chart
    end
  end

  resources :mandala_items, only: [:edit, :update]

  root to: "annual_themes#index"
end
