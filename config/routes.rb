Rails.application.routes.draw do
  #resources :courses
  root 'courses#index'
  get '/courses' => 'courses#show', as: :course
end