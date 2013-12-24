FieldInspector::Application.routes.draw do

  root :to => 'sessions#new'
  get "sign_up" => "users#new", :as => "sign_up"
  get "log_in"  => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "locations/json", to: "locations#location_json"
  get "/locations/forecast_json", to: "forecasts#forecast_json"

  #   match 'products/:id' => 'catalog#view'

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # resources :photos  #use this for heroku testing until all nested resources are working
  resources :locations do
    resources :forecasts, only: [:index]
    resources :reports do
      resources :photos
    end
  end

  resources :users
  # resources :home, only: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  # resources :photos

end
