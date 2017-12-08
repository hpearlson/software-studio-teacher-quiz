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

  get 'quizzes/aboutquizzes', :to => 'quizzes#about'
  
  get 'quizzes/about', :to => 'quizzes#aboutQuizme'
  
  get 'quizzes/endofround', :to => 'quizzes#roundEnd'
  
  #get 'quizzes/overrideIncorrect', :to => 'quizzes#overrideIncorrect'
  
  resources :quizzes do
    member do
      get :review
      post :check_answer
    end
    collection do
      get :take_remedial_quiz
      get :overrideIncorrect
    end
  end
  
  
  
end
