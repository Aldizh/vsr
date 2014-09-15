Vsr::Application.routes.draw do

  get "reseller1s/addClient"
  get "reseller1s/addClientSubmit"
  post "reseller1s/addClientSubmit"
  get "reseller1s/testMethod"
  get "reseller1s/viewSelectedTariff"
  get "reseller1s/viewSelected"
  get "reseller1s/viewMyTariff"
  post "reseller1s/viewMyTariff"
  get "reseller1s/viewActiveCalls"
  get "reseller1s/viewMyClients"
  get "reseller1s/addPayment"
  post "reseller1s/addPayment"
  get "reseller1s/payment_history"
  get "reseller1s/filteredPaymentHistory"
  post "reseller1s/filteredPaymentHistory"
  get "reseller1s/viewMyClientsCDR"
  post "reseller1s/viewMyClientsCDR"
  get "reseller1s/viewMyTariff"
  get "reseller1s/viewClientsTariff"
  get "reseller1s/agentsTariffs"
  get "reseller1s/viewTariff"
  get "reseller1s/viewTariff1"
  get "reseller1s/editTariff"
  get "reseller1s/editTariffSubmit"
  post "reseller1s/editTariffSubmit"
  get "reseller1s/createTariff"
  get "reseller1s/createTariffSubmit"
  post "reseller1s/createTariffSubmit"
  get "reseller1s/createTariffFromBase"
  get "reseller1s/createTariffFromBaseSubmit"
  post "reseller1s/createTariffFromBaseSubmit"
  get "reseller1s/addNewTariff"
  post "reseller1s/addNewTariff"
  get "reseller1s/addNewTariffSubmit"
  post "reseller1s/addNewTariffSubmit"

  get "reseller2s/viewSelectedTariff"
  get "reseller2s/viewSelected"
  get "reseller2s/viewActiveCalls"
  get "reseller2s/viewMyResellers"
  get "reseller2s/addPayment"
  post "reseller2s/addPayment"
  get "reseller2s/payment_history"
  get "reseller2s/filteredPaymentHistory"
  post "reseller2s/filteredPaymentHistory"
  get "reseller2s/viewMyResellersCDR"
  post "reseller2s/viewMyResellersCDR"
  get "reseller2s/viewMyTariff"
  post "reseller2s/viewMyTariff"
  get "reseller2s/viewResellers1Tariff"
  get "reseller2s/addReseller1"
  get "reseller2s/addReseller1Submit"
  post "reseller2s/addReseller1Submit"
  get "reseller2s/agentsTariffs"
  get "reseller2s/viewTariff"
  get "reseller2s/viewTariff1"
  get "reseller2s/editTariff"
  get "reseller2s/editTariffSubmit"
  post "reseller2s/editTariffSubmit"
  get "reseller2s/createTariff"
  get "reseller2s/createTariffSubmit"
  post "reseller2s/createTariffSubmit"
  get "reseller2s/addNewTariff"
  post "reseller2s/addNewTariff"
  get "reseller2s/addNewTariffSubmit"
  post "reseller2s/addNewTariffSubmit"

  post "reseller3s/calculateProfit"
  get "reseller3s/calculateProfit"
  get "reseller3s/viewSelectedTariff"
  get "reseller3s/viewSelected"
  get "reseller3s/viewActiveCalls"
  get "reseller3s/viewMyResellers"
  get "reseller3s/addPayment"
  post "reseller3s/addPayment"
  get "reseller3s/payment_history"
  get "reseller3s/filteredPaymentHistory"
  post "reseller3s/filteredPaymentHistory"
  get "reseller3s/viewMyResellersCDR"
  post "reseller3s/viewMyResellersCDR"
  get "reseller3s/viewMyTariff"
  post "reseller3s/viewMyTariff"
  get "reseller3s/viewResellers2Tariff"
  get "reseller3s/addReseller2"
  get "reseller3s/addReseller2Submit"
  post "reseller3s/addReseller2Submit"
  get "reseller3s/agentsTariffs"
  get "reseller3s/viewTariff"
  get "reseller3s/viewTariff1"
  get "reseller3s/editTariff"
  get "reseller3s/editTariffSubmit"
  post "reseller3s/editTariffSubmit"
  get "reseller3s/createTariff"
  get "reseller3s/createTariffSubmit"
  post "reseller3s/createTariffSubmit"
  get "reseller3s/addNewTariff"
  post "reseller3s/addNewTariff"
  get "reseller3s/addNewTariffSubmit"
  post "reseller3s/addNewTariffSubmit"


  get "users/viewMyResellers"
  get "users/addPayment"
  post "users/addPayment"
  get "users/addReseller3"
  get "users/tariffs"
  get "users/addReseller3Submit"
  post "users/addReseller3Submit"
  get "users/viewTariff"
  get "users/viewTariff1"
  get "users/editTariffSubmit"
  post "users/editTariffSubmit"
  get "users/editTariff"
  get "users/createTariff"
  get "users/createTariffSubmit"
  post "users/createTariffSubmit"
  get "users/addNewTariff"
  post "users/addNewTariff"
  get "users/addNewTariffSubmit"
  post "users/addNewTariffSubmit"

  
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
