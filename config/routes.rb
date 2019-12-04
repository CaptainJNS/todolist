Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :session, only: %i[create destroy]

      resources :users, only: :create

      resources :projects do
        resources :tasks do
          resources :comments, only: %i[index create destroy]
        end
      end

      put 'tasks/:id/complete', to: 'tasks#complete'
    end
  end
end
