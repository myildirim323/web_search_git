Rails.application.routes.draw do
  resources :users
  root to: 'users#index'
  get 'find_user', to: 'users#find_user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
