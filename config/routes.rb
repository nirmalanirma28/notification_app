Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :developers
  resources :teams do
    collection do
      post 'add-developers', to: 'teams#add_developers'
      post 'trigger-notification', to: 'teams#trigger_notification'
    end
  end
end
