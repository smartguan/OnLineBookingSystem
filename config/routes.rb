Cs169::Application.routes.draw do

  get "users/show"

  get "users/new"
  
  root :to => "homepage#homepage"
  get "homepage/homepage"


  get "users/add"

  get "users/login"

  get "users/delete"

  get "users/update"

  get "users/profile"

  # Routes for User controller
  match '/users/add', to: 'users#add'
  match '/users/login', to: 'users#login'
  match '/users/delete', to: 'users#delete'
  match '/users/update', to: 'users#update'
  match '/users/profile', to: 'users#profile'
  

  # Routes for Registration controller

  match '/registrations/schedule', to: 'registrations#getSchedule', :via => :get, :default => {format: "json"}
  match '/admin/createSection', to:'registrations#createSection', :via => :post, :default => {format: "json"}

  match '/Registrations/getSchedule', to: 'registrations#getSchedule', :via => :get, :default => {format: "json"}
  match '/Admin/createSection', to:'registrations#createSection', :via => :post, :default => {format: "json"}
  match '/Admin/editSection', to:'registrations#editSection', :via => :post, :default => {format: "json"}
  match '/Admin/deleteSection', to:'registrations#deleteSection', :via => :post, :default => {format: "json"}

  match '/Registrations/viewOneSection', to: 'registrations#viewOneSection', :via => :get, :default => {format: "json"}
  # match '/Registrations/viewEnrolledSections', to: 'registrations#viewEnrolledSections', :via => :get, :default => {format: "json"}
  # match '/Registrations/register', to: 'registrations#register', :via => :post, :default => {format: "json"}
  # match '/Registrations/drop', to: 'registrations#drop', :via => :post, :default => {format: "json"}
  
  match '/admin' => 'application#admin'
  
  post 'users/new', to: "users#create"
  resources :users
  # match '/signup',  to: 'users#new'

end
