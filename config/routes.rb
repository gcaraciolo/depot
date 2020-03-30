Rails.application.routes.draw do
  root 'store#index', as: 'store_index'

  resources :orders
  resources :line_items do
    post 'decrease-quantity', on: :member
  end

  resources :carts, only: [:show, :destroy]
  resources :products do
    get :who_bought, on: :member
  end
end
