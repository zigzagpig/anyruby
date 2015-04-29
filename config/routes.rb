Rails.application.routes.draw do
  get 'demo/search'

  get 'demo/new_website'

  get 'demo/show_website'

  get 'demo/new_ask'

  get 'demo/show_ask'

  
  root 							      'static_pages#home'
  get  		'help'			=>  'static_pages#help'
  get  		'about'			=>	'static_pages#about'
  get  		'contact'		=>	'static_pages#contact'
  get  		'signup'		=>	'users#new'
  get  		'login'			=>	'sessions#new'
  post 		'login'			=>	'sessions#create'
  delete 	'logout'		=>	'sessions#destroy'
  resources	:users do
    resources :articles
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
