Rails.application.routes.draw do
  resources :line_items
  resources :carts, only: [:show, :destroy]
  root 'store#index', as: 'store_index'
  resources :products
end
