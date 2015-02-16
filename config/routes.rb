Rails.application.routes.draw do

  get 'users/new'
  get    'signup'  =>  'users#new'
  get    'login'   =>  'sessions#new'
  post   'login'   =>  'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  get 'password_resets/new'
  get 'password_resets/edit'

  post '/quizzes/:id' => 'selections#create'
  
  resources :categories do
    resources :quizzes
  end

    resources :quizzes do 
    resources :questions
  end 

  resources :questions do
    resources :answers, only: [:new, :create, :update] do
      resources :selections, only: [:create, :update]
    end
  end

  root 'welcome#index'



end