Rails.application.routes.draw do
  # OmniAuth routes must be outside the locale scope to handle callbacks correctly
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, skip: [ :omniauth_callbacks, :registrations, :passwords ]

    resources :annual_themes do
      member do
        get :chart
      end
      resources :monthly_goals
    end

    resources :mandala_items, only: [ :edit, :update ]
    resources :daily_tasks, only: [ :index, :create, :update, :destroy ] do
      collection do
        get :calendar
      end
    end
    resources :reflections

    root to: "annual_themes#index"
  end
end
