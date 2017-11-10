Rails.application.routes.draw do
  
  root :to => redirect('/access/home')
  
  get 'access/home', :to => 'access#home'
  get 'home', :to => 'access#home'
  get 'admin', :to => 'access#menu'
  get 'access/menu'
  get 'access/login'
  post 'access/attempt_login'
  get 'access/logout'
  get 'access/accountType'
  

  post 'students/signup', :to => 'students#register'
  get 'students/signup', :to => 'students#signup'
  
  resources :courses
  
  resources :students
  
  resources :teachers
  
  resources :quizzes do
    collection do
      post :check_answer
      get :review
    end
  end

end
