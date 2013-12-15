FieldInspector::Application.routes.draw do

  get "sign_up" => "users#new", :as => "sign_up"
  get "log_in"  => "sessions#new", :as => "log_in"
  get "log_out" => "sessions#destroy", :as => "log_out"


  #   match 'products/:id' => 'catalog#view'

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
  get 'locations/json', to: 'locations#location_json'

  root :to => 'home#index'

  resources :locations do
    resources :forecasts, only: [:index]
    resources :reports do
      resources :photos
    end
  end

  resources :users
  resources :sessions, only: [:new, :crete, :destroy]

end
