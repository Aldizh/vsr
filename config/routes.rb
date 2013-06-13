Vsr::Application.routes.draw do

  get"clients/viewMyTariff"

  get "reseller1s/viewActiveCalls"
  get "reseller1s/viewMyClients"
  get "reseller1s/addPayment"
  post "reseller1s/addPayment"
  get "reseller1s/payment_history"
  get "reseller1s/filteredPaymentHistory"
  post "reseller1s/filteredPaymentHistory"
  get "reseller1s/viewMyClientsCDR"
  get "reseller1s/viewMyTariff"
  get "reseller1s/viewClientsTariff"


  get "reseller2s/viewActiveCalls"
  get "reseller2s/viewMyResellers"
  get "reseller2s/addPayment"
  post "reseller2s/addPayment"
  get "reseller2s/payment_history"
  get "reseller2s/filteredPaymentHistory"
  post "reseller2s/filteredPaymentHistory"
  get "reseller2s/viewMyResellersCDR"
  get "reseller2s/viewMyTariff"
  get "reseller2s/viewResellers1Tariff"

  get "reseller3s/viewActiveCalls"
  get "reseller3s/viewMyResellers"
  get "reseller3s/addPayment"
  post "reseller3s/addPayment"
  get "reseller3s/payment_history"
  get "reseller3s/filteredPaymentHistory"
  post "reseller3s/filteredPaymentHistory"
  get "reseller3s/viewMyResellersCDR"
  get "reseller3s/viewMyTariff"
  get "reseller3s/viewResellers2Tariff"

  get "users/viewMyResellers"

  get "sessions/new"
  

  get "sessions/create"

  get "sessions/destroy"

  resources :sessions
  resources :clients
  resources :reseller1s
  resources :reseller2s
  resources :reseller3s
  resources :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sessions#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
