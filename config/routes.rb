Rails.application.routes.draw do
  root        'static_pages#home'
  get         '/help',            to: 'static_pages#help'
  get         '/about',           to: 'static_pages#about'
  get         '/contact',         to: 'static_pages#contact'
  get         '/signup',          to: 'users#new'
  get         '/login',           to: 'sessions#new'
  post        '/login',           to: 'sessions#create'
  delete      '/logout',          to: 'sessions#destroy'
  get         '/weekly_report',   to: 'user_entries#weekly_report'
  resources   :users
  resources   :account_activations,   only: [:edit]
  resources   :password_resets,       only: [:new, :create, :edit, :update]
  resources   :user_entries,          only: [:edit, :update, :create, :destroy]

  namespace :api do
    namespace :v1 do
      
      resources :users,         only: [:index, :create, :show, :update, :destroy]
      resources :user_entries,  only: [:index, :create, :show, :update, :destroy]
    
      post  'login',  to: 'sessions#create'
    
    end
  end
end
