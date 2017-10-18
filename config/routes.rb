Rails.application.routes.draw do
  resources :courses
  root :to => redirect('/courses')
  
  resources :students
  #get 'student/index' => 'student#index'

end
