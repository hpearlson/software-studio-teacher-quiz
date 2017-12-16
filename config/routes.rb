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
  
  get 'auth/:provider/callback', to: 'teachers#create_from_google'
  get 'auth/failure', to: redirect('/')

  post 'students/signup', :to => 'students#register'
  get 'students/signup', :to => 'students#signup'
  
  resources :courses
  
  resources :students
  
  resources :teachers

  get 'quizzes/aboutquizzes', :to => 'quizzes#about'
  
  get 'quizzes/about', :to => 'quizzes#aboutQuizme'
  
  get 'quizzes/endofround', :to => 'quizzes#roundEnd'
  
  get 'quizzes/endofquiz', :to => 'quizzes#endPage'
  
  resources :quizzes do
    member do
      get :review
      post :check_answer
      get :take_subset_quiz, :as => :restart
    end
    collection do
      get :take_remedial_quiz
      get :overrideIncorrect
    end
  end
  
  
  
end
