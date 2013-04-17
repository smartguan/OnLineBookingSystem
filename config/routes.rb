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

  # match "/users/profile", to: 'users#profile'
  post "/registrations/viewEnrolledSections" => "mocks#test_viewEnrolledSections"
  match "/users/profile", to: "mocks#test_Profile"
  post "/users/update_password" => "users#updatePassword"

  get "users/addSection"
  get "users/update_password"



  # For User tests
  match 'Users/test', to: 'users#testView'
  match 'Users/test2', to: 'users#testView2'

  # Routes for Users controller
  match '/Users/login', to: 'users#login'
  match '/Users/update', to: 'users#update'
  match '/Users/updatePassword', to: 'users#updatePassword'
  match '/Users/profile', to: 'users#profile'
  match '/Users/logout', to: 'users#logout'

  # Routes for MemberStudents Controller
  match '/MemberStudents/add', to: 'member_students#add'
  
  # Routes for AnonymousStudents Controller
  match '/AnonymousStudents/add', to: 'anonymous_students#add'
  
  # Routes for Admin Controller
  match '/Admin/addInstructor', to: 'admin#addInstructor'
  match '/Admin/delete', to: 'admin#delete'
  match '/Admin/exportCsv', to: 'admin#exportCsv'

  # I don't know what these are, so I commented them out
  # If I did something wrong, please let me know so that 
  # somebody can correct me. I appologize ahead~~(By Seth)
  # match '/Registrations/viewEnrolledSections', to: 'sections#viewEnrolledSections'
  # match '/Registrations/register', to: 'sections#register'
  # post '/sections/register', to: 'sections#register'
  # match '/Registrations/drop', to: 'sections#drop'

  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv #
  # Please Keep all routes below unchanged. 
  # Otherwise the BE for registration will fail
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv #
  # Routes for Registration controller
  match '/Registrations/getEnrolledSections', to: 'registrations#getEnrolledSections'
  match '/Registrations/register', to: 'registrations#register'
  match '/Registrations/drop', to: 'registrations#drop'

  # Routes for Sections controller (previously Admin)
  match '/Sections/create', to:'sections#create'
  match '/Sections/edit', to:'sections#edit'
  match '/Sections/delete', to:'sections#delete'
  match '/Sections/getAllSections', to: 'sections#getAllSections'
  match '/Sections/getSectionByID', to: 'sections#getSectionByID'
  match '/Sections/getAvailableSectionsFromNowOn', to: 'sections#getAvailableSectionsFromNowOn'
  match '/Sections/getAvailableSectionsByDateAndTime', to: 'sections#getAvailableSectionsByDateAndTime'
  # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #
  # Please Keep all routes above unchanged. 
  # Otherwise the BE for registration will fail
  # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #

  # match '/Registrations/viewEnrolledSections', to: 'sections#viewEnrolledSections', :via => :get, :default => {format: "json"}
  # match '/Registrations/register', to: 'sections#register', :via => :post, :default => {format: "json"}
  # match '/Registrations/drop', to: 'sections#drop', :via => :post, :default => {format: "json"}

  
  match '/admin' => 'application#admin'
  match '/newadmin' => 'application#newadmin'
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
