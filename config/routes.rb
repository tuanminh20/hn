Rails.application.routes.draw do
  namespace :api do
    get 'stories/index'
    get 'stories/show'
  end
  root 'stories#index'
  get 'stories/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
