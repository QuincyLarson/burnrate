Rails.application.routes.draw do
  resources :users
  root to: 'visitors#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
  get 'page_two' => 'visitors#page_two'
  get 'page_three' => 'visitors#page_three'
  get 'page_four' => 'visitors#page_four'
  get 'page_five' => 'visitors#page_five'
end
