Rails.application.routes.draw do
  devise_for :users
  
  resources :keywords, only: [:index, :new, :create, :show, :destroy] do
    collection do
      delete :delete_all
    end
  end

  root to: 'keywords#index'
end
