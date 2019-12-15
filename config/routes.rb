Rails.application.routes.draw do
  apipie

  namespace :api do
    namespace :v1 do
      resource :session, only: %i[create destroy]

      resources :users, only: :create

      resources :projects do
        resources :tasks, shallow: true do
          resources :comments, only: %i[index create destroy]
        end
      end
    end
  end
end
