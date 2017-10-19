Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'

  namespace :api, { defaults: { format: :json } } do
    namespace :v1 do
      resources :projects do
        resources :tasks
      end
    end
  end
end
