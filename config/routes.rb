Rails.application.routes.draw do
  resources :tasks_tags
  resources :posts_tags
  resources :tags
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
