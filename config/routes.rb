Rails.application.routes.draw do
  root "sessions#new"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/dashboard", to: "dashboard#index"

  resources :users
  resources :campaigns
  

  resources :client_companies, path: :clients, as: :clients

  resources :campaigns do
    resources :images, only: [:index, :new, :create, :show]
  end

  resources :images, only: [] do
    collection do
      get :moderation_queue
      get :moderation_history
    end
  
    member do
      post :approve
      post :reject
    end
  end 
  resources :images 
end
