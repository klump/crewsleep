Crewservices::Application.routes.draw do
  #get "api/fetch_person"

  #get "api/add_alarm"

  post "api/v1/book_place" => "api#book_place"

  #get "api/finish_alarm"

  get "api/v1/fetch_place_info" => "api#fetch_place_info"
  get "api/v1/fetch_places" => "api#fetch_places"
  post "api/v1/save_places" => "api#save_places"
  
  get 'api/v1/fetch_person' => 'api#fetch_person'

  get "api/v1/fetch_active_alarms" => "api#fetch_active_alarms"
  
  post "api/v1/set_alarm" => "api#set_alarm"
  post "api/v1/delete_alarm" => "api#delete_alarm"
  post "api/v1/finish_alarm" => "api#finish_alarm"
  post "api/v1/poke" => "api#poke"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
