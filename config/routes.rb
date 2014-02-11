PlanbAdmin::Application.routes.draw do

  resources :passes
  get 'passes/download/:id', to: 'passes#download'
  get 'passes/qrcode/:id', to: 'passes#qrcode'
  post 'passes/:version/devices/:device_library_identifier/registrations/:pass_type_identifier/:serial_number', to: 'passes#register_device_for_pass', pass_type_identifier: /.*/
  get 'passes/:version/devices/:device_library_identifier/registrations/:pass_type_identifier', to: 'passes#fetch_pass_serial_numbers_for_device', pass_type_identifier: /.*/
  get 'passes/:version/passes/:pass_type_identifier/:serial_number', to: 'passes#fetch_latest_pass', pass_type_identifier: /.*/
  delete 'passes/:version/devices/:device_library_identifier/registrations/:pass_type_identifier/:serial_number', to: 'passes#unregister_device_for_pass', pass_type_identifier: /.*/
  post 'passes/:version/log', to: 'passes#error_log'
  post 'passes/reconcile/:consumer_id', to: 'passes#reconcile_pass_and_consumer'
  get '/passes/account/:retailer_id/:pass_type_identifier/:serial_number/:authentication_token', to: 'passes#account', pass_type_identifier: /.*/

  resources :advertisements
  resources :crumbs
# resources :retailers
  resources :beacons
  resources :stores

  get 'blog', to: 'blog#index'  
  get 'shop', to: 'shop#index'
  get 'shop/qr/:id', to: 'shop#qr'

  get 'dashboard', to: 'stores#dashboard'

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
  root :to => 'stores#dashboard'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
