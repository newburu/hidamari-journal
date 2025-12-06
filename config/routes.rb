Rails.application.routes.draw do
  devise_for :users

  resources :annual_themes do
    member do
      get :chart
    end
    resources :monthly_goals
  end

  resources :mandala_items, only: [:edit, :update]
  resources :daily_tasks, only: [:index, :create, :update, :destroy]
  resources :reflections

  root to: "annual_themes#index"
end
