Rails.application.routes.draw do
  resources :tasks do
    member do
      patch :up
      patch :down
    end
  end

  resources :projects
end
