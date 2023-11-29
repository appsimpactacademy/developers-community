Rails.application.routes.draw do
  
  resources :pages, controller: 'pages' do
    member do
      post :follow
      delete :unfollow
    end
  end

  resources :notifications, only: [:index, :destroy]
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get '/generate_otp', to: 'users/sessions#generate_otp', as: :generate_otp
    get '/session_id/:id', to: 'users/sessions#session_id', as: :session_id
    post '/verify_otp', to: 'users/sessions#verify_otp', as: :verify_otp
  end


  # for hide & unhide the posts
  resources :posts do
    member do
      post 'hide'
      post 'undo_hide'
      post 'toggle_hide'
      post 'repost_with_thought', to: 'reposts#repost_with_thought', as: 'repost_thought'
    end
    resources :reposts
    resources :comments
    resources :user_reactions, only: [:create, :destroy]
  end

  get 'hidden_posts', to: 'posts#hidden'

  post 'search', to: 'search#index', as: 'search'
  post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'
  get '/search_results', to: 'search#results', as: 'search_results'

  get "password", to: "passwords#edit", as: :edit_password
  patch "password", to: "passwords#update"

  resources :events do
    collection do
      get 'calendar_events'
    end
  end

  root 'home#index'
  get '/home', to: 'home#index', as: :home
  get '/home/sort', to: 'home#sort', as: :home_sort
  get '/profile_views', to: 'home#profile_views'
  
  get 'member/:id', to: 'members#show', as: :member  
  get 'member/:id/edit', to: 'members#edit', as: :edit_member
  patch 'member/:id', to: 'members#update', as: :update_member

  get 'members/fetch_country_states', to: 'members#fetch_country_states', as: :fetch_country_states

  get 'edit_description/:id', to: 'members#edit_description', as: 'edit_member_description'
  patch 'update_description', to: 'members#update_description', as: 'update_member_description'

  get 'edit_personal_details', to: 'members#edit_personal_details', as: 'edit_member_personal_details'
  patch 'update_personal_details', to: 'members#update_personal_details', as: 'update_member_personal_details'

  get 'member-connections/:id', to: 'members#connections', as: 'member_connections'
  get '/all_messages', to: 'messages#all_messages'

  resources :jobs
  resources :job_categories
  resources :work_experiences
  resources :connections
  resources :skills
  resources :messages, only: [:index]
  resources :shares, only: [:new, :create,:index]
  resources :articles 


  resources :groups do
    member do
      post 'follow'
      delete 'unfollow'
      get 'followers', to: 'groups#followers', as: 'group_followers'
    end
  end

  resources :users do
    resources :posts
    resources :jobs
    resources :my_jobs, only: [:index]
    resources :my_events, only: [:index]
    resources :my_article, only: [:index]
  end

  resources :members, controllers: 'members' do
    member do
      post :follow
      delete :unfollow
      get :followers_and_following
    end
    collection do
      get :fetch_country_states
    end
  end

  resources :likes, only: [:create, :destroy]

  resources :followers, only: [:show] do
    member do
      get :show_followers
    end
  end
end
