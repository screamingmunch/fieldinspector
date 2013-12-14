FieldInspector::Application.routes.draw do

  #   match 'products/:id' => 'catalog#view'

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
  get 'locations/json', to: 'locations#location_json'

  root :to => 'home#index'

  resources :reports do
    resources :photos
  end

  resources :locations do
    resources :forecasts
  end
  resources :photos, :reports, :locations

end
