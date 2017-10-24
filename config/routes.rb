Rails.application.routes.draw do
  
  root :to => redirect('/courses')
  
  get 'admin', :to => 'access#menu'
  get 'access/menu'
  get 'access/login'
  post 'access/attempt_login'
  get 'access/logout'

  resources :courses
  
  resources :students
  #get 'student/index' => 'student#index'
  
  resources :teachers

end
