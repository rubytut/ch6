Ch3SampleApp::Application.routes.draw do
  
  get "sessions/new"

  # Our method for displaying the user show page will follow 
  # the conventions of the REST architecture.
  # The REST design style emphasizes representing data as
  # resources that can be created, shown, updated, or destroyed.
  #
  # When following REST principles, resources are typically refereced
  # using teh resource name and a unique identifier. What that
  # means in the context of users - which we're now thinking of as
  # a Users resource - is that we should view the user id 1 by issuing
  # a GET requert to the URL '/users/1'.
  resources :users do
    member do
      # GET /users/1/following || /users/1/followers
      get :following, :followers
    end
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resources :microposts, :only => [:create, :destroy]

  # We remove the following line because the one additional resource line 
  # doesen't just add a working '/users/1' URL; it endows our sample 
  # application with all the action needed for a RESTful User resource,
  # along wit a large number of named routes for generating user URLs.
  ##get "users/new"

#  the "match '/signup'" gives us the named route signup_page,
#  which we put to use in Listing 5.30
   match '/signup', :to => 'users#new'

   match '/signin', :to => 'sessions#new'
   match '/signout', :to => 'sessions#destroy'

#   match '/', :to => 'pages#home'
   match '/contact', :to => 'pages#contact'
   match '/about', :to => 'pages#about'
   match '/help', :to => 'pages#help'

   root :to => 'pages#home'
##  get "pages/home"

##  get "pages/contact"

##  get "pages/about"

##  get "pages/help"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
