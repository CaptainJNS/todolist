Rails.application.routes.draw do
  post 'auth/sign_in', to: 'authentication#sign_in'
  delete 'auth/sign_out', to: 'authentication#sign_out'
  post 'auth', to: 'users#create'

  resources :projects do
    resources :tasks, only: %i[index create]
  end

  resources :tasks, except: %i[index create] do
    resources :comments, only: %i[index create]
  end

  resources :comments, only: :destroy

  put 'tasks/:id/complete', to: 'tasks#complete'
end
