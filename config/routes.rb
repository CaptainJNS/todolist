Rails.application.routes.draw do
  resources :users, param: :_username
  post 'auth/sign_in', to: 'authentication#sign_in'
  delete 'auth/sign_out', to: 'authentication#sign_out'
  post 'auth', to: 'users#create'
end
