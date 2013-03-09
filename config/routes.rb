Cs169::Application.routes.draw do
  get "users/add"

  get "users/login"

  get "users/delete"

  get "users/update"

  get "users/profile"
  





















  
  # get "add" => "users#new", :as => "add"
  # get 'users/add'
  post 'users/add/' => "users#create"
  root :to => "users#login"
  resources :users
end
