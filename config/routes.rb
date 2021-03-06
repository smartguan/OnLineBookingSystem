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

  match "/new_home", to: "homepage#new_homepage"
  match "/dyn_admin", to: "application#dyn_admin"
  # match "/users/profile", to: 'users#profile'
  # post "/registrations/viewEnrolledSections" => "mocks#test_viewEnrolledSections"
  # match "/users/profile", to: "mocks#test_Profile"
  match "/users/profile", to: "users#profile"
  # match "/Registrations/viewEnrolledSections", to: "registrations#viewEnrolledSections"
  match '/Users/logout', to: 'users#logout'
  post "/users/update_password" => "Registrations#updatePassword"

  get "users/addSection"
  get "users/update_password"


  match '/Users/show', to: 'users#show'
  match 'Users/testSection', to: 'users#testSection'


  # For User tests
  match 'Users/test', to: 'users#testView'
  match 'Users/test2', to: 'users#testView2'
  match 'Users/test3', to: 'users#testView3'
  match '/testUserInfo', to: 'users#userinfo'
  match 'Users/tabs', to: 'users#userTabs'

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

  # Routes for Instructors Controller
  match '/Instructors/getAllInstructors', to: 'instructors#getAllInstructors'
  match '/Instructors/getAvailableInstructors', to: 'instructors#getAvailableInstructors'
  
  # Routes for Admin Controller
  match '/Admin/init', to: 'admin#init'
  match '/Admin/addInstructor', to: 'admin#addInstructor'
  match '/Admin/delete', to: 'admin#delete'
  match '/Admin/exportUsers', to: 'admin#exportUsers'
  match '/Admin/exportSections', to: 'admin#exportSections'
  match '/Admin/allUsers', to: 'admin#allUsers'

  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv #
  # Please Keep all routes below unchanged. 
  # Otherwise the BE for registration will fail
  # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv #
  # Routes for Registration controller

  # match '/Registrations/viewEnrolledSections', to: 'registrations#viewEnrolledSections'

  match '/Registrations/getEnrolledSections', to: 'registrations#getEnrolledSections'
  match '/Registrations/register', to: 'registrations#register'
  match '/Registrations/drop', to: 'registrations#drop'
  match '/Registrations/dropAndGetEnrolledSections', to: 'registrations#dropAndGetEnrolledSections'

  # Routes for Sections controller (previously Admin)
  match '/Sections/create', to:'sections#create'
  match '/Sections/edit', to:'sections#edit'
  match '/Sections/delete', to:'sections#delete'
  match '/Sections/getAllSections', to: 'sections#getAllSections'
  match '/Sections/getSectionByID', to: 'sections#getSectionByID'
  match '/Sections/getSectionsByInstructor', to: 'sections#getSectionsByInstructor'
  match '/Sections/getAvailableSectionsFromNowOn', to: 'sections#getAvailableSectionsFromNowOn'
  match '/Sections/getAvailableSectionsByDateAndTime', to: 'sections#getAvailableSectionsByDateAndTime'
  # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #
  # Please Keep all routes above unchanged. 
  # Otherwise the BE for registration will fail
  # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #

  match '/admin' => 'application#admin'
  match '/newadmin' => 'application#newadmin'
  match '/oldadmin' => 'application#oldadmin'
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
