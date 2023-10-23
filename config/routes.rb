Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get '/generate_otp', to: 'users/sessions#generate_otp', as: :generate_otp
    get '/session_id/:id', to: 'users/sessions#session_id', as: :session_id
    post '/verify_otp', to: 'users/sessions#verify_otp', as: :verify_otp
  end

  get 'member/:id', to: 'members#show', as: 'member'
  get 'edit_description', to: 'members#edit_description', as: 'edit_member_description'
  patch 'update_description', to: 'members#update_description', as: 'update_member_description'

  get 'edit_personal_details', to: 'members#edit_personal_details', as: 'edit_member_personal_details'
  patch 'update_personal_details', to: 'members#update_personal_details', as: 'update_member_personal_details'
  get 'member-connections/:id', to: "members#connections", as: "member_connections"

  resources :work_experiences
  resources :connections
  resources :messages, only: [:index]
  get '/all_messages', to: 'messages#all_messages'

  resources :skills
end
