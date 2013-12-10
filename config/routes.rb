FieldInspector::Application.routes.draw do

  #   match 'products/:id' => 'catalog#view'

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  root :to => 'home#index'
  resources :photos

end
