Rails.application.routes.draw do
  root 'board#index'

  resources :board
end
