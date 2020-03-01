Rails.application.routes.draw do
  resources :categories
  get     "login" => "sessions#new"
  post    "login"    => "sessions#create"
  delete  "logout"   => "sessions#destroy"
  resources :users,except: :index do
    resources :microposts
  end
  # get 'microposts', controller: "microposts",action: :index
  # post 'microposts', controller: "microposts",action: :create
  resources :microposts

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home_page'
end
