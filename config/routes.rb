Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books
  resources :books do
    resources :comments, module: :books, only: %i(create destroy)
  end
  resources :users, only: %i(index show)
  resources :reports
  resources :reports do
    resources :comments, module: :reports, only: %i(create destroy)
  end
end
