Cs169::Application.routes.draw do

  get "registrations/new"

  get "users/show"

  get "users/new"
  
  root :to => "homepage#homepage"
  get "homepage/homepage"

  get "users/add"

  get "users/login"

  get "users/delete"

  get "users/update"

  get "users/profile"

  # For User tests
  match 'Users/test', to: 'users#testView'

  # Routes for User controller
  match '/Users/add', to: 'users#add'
  match '/Users/login', to: 'users#login'
  match '/Users/delete', to: 'users#delete' 
  match '/Users/update', to: 'users#update'
  match '/Users/profile', to: 'users#profile'
  match '/Users/logout', to: 'user#logout'

  # Routes for Registration controller

  match '/Registrations/getSchedule', to: 'sections#getSchedule'
  match '/Registrations/viewOneSection', to: 'sections#viewOneSection'
  match '/Registrations/viewEnrolledSections', to: 'sections#viewEnrolledSections'
  match '/Registrations/register', to: 'sections#register'
  match '/Registrations/drop', to: 'sections#drop'

  match '/Admin/createSection', to:'sections#createSection'
  match '/Admin/editSection', to:'sections#editSection'
  match '/Admin/deleteSection', to:'sections#deleteSection'

  match '/Registrations/viewOneSection', to: 'sections#viewOneSection'
  # match '/Registrations/viewEnrolledSections', to: 'sections#viewEnrolledSections', :via => :get, :default => {format: "json"}
  # match '/Registrations/register', to: 'sections#register', :via => :post, :default => {format: "json"}
  # match '/Registrations/drop', to: 'sections#drop', :via => :post, :default => {format: "json"}

  
  match '/admin' => 'application#admin'
  match '/reservation' => 'application#reservation'

  post '/users/new', to: 'users#create'
  #resources :users
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"
end
