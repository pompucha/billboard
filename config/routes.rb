Rails.application.routes.draw do
  get 'songs/index'
  get 'songs/show'
  get 'songs/new'
  get 'songs/edit'
  get 'artists/index'
  get 'artists/show'
  get 'artists/new'
  get 'artists/edit'
  root 'board#index'

  resources :board

  # resources :artist do
  #   resources :song
  # end
end
