Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  resources :recipes
  resources :ingredients
  resources :meals
  resources :transactions
  get 'recipes/:id/add', to: 'recipes#add', as: 'add_to_recipe'

end
