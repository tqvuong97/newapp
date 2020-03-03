Rails.application.routes.draw do
  get 'comments/create'
  get 'comments/update'
  get 'comments/destroy'
  resources :categories
  get     "login" => "sessions#new"
  post    "login"    => "sessions#create"
  delete  "logout"   => "sessions#destroy"
  resources :users,except: :index do
    resources :microposts
  end
  # get 'microposts', controller: "microposts",action: :index
  # post 'microposts', controller: "microposts",action: :create
  resources :microposts do
    resources :comments
  end
  resources :comments



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home_page'
end
