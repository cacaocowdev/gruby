Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  get 'transactions/statistics', to: 'finances#home', as: 'finances'
  resources :recipes
  resources :meals
  resources :transactions
  resources :todos

end
