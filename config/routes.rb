Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  get 'member/:id', to: 'members#show', as: 'member'

end
