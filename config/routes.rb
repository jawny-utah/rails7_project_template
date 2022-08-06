Rails.application.routes.draw do
  get '/auth/:provider/callback' => 'sessions#omniauth'
  resource :sessions, only: :destroy

  root "pages#index"
end
