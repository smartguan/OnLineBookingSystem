Cs169::Application.routes.draw do
  get "users/new"

  get "users/add"

  get "users/login"

  get "users/delete"

  get "users/update"

  get "users/profile"
  

  # # Routes for User controller
  # match '/Users/add', to: 'users#add'
  # match '/Users/login', to: 'users#login'
  # match '/Users/delete', to: 'users#delete'
  # match '/Users/update', to: 'users#update'
  # match '/Users/profile', to: 'users#profile'
  
  post "users/new", to: "users#create"
  root :to => "users#login"  #login should be on the home page
end
