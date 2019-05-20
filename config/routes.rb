Rails.application.routes.draw do

  root 'board#index'

  resources :board

  resources :artist 
  
  resources :song

end
