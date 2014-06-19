Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :sessions, only: [:new, :created, :destroy]
    resources :words
    resources :categories
    resources :monitors , only: [:index]

    root to: 'sessions#new'

    match '/signin' => 'sessions#create', via: :post
    match '/signout' => 'sessions#destroy', via: :post
    match '/monitors/import' => 'monitors#import', via: :post

    match '/monitors/export' => 'monitors#export', via: :get
    match '/signin' => 'sessions#new', via: :get
    match '/home' => 'static_pages#home', via: :get
  end

  resources :categories
  resources :relationships, only: [:create, :destroy]
  resources :sessions, only: [:new, :created, :destroy]
  resources :users
  resources :words

  root to: 'static_pages#home'

  match 'signin' => 'sessions#create', via: :post

  match '/home' => 'static_pages#home', via: :get
  match '/about' => 'static_pages#about', via: :get
  match '/contact' => 'static_pages#contact', via: :get
  match '/signin' => 'sessions#new', via: :get
  match '/signout' => 'sessions#destroy', via: :get
  match '/signup' => 'users#new', via: :get
end
