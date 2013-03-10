Cs169::Application.routes.draw do

  get "users/show"

  get "users/new"

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
  
  post "users/new", to: "users#create"
  root :to => "users#login"  #login should be on the home page
end
