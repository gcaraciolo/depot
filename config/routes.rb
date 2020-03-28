Rails.application.routes.draw do
  resources :line_items do
    post 'decrease-quantity', to: 'line_items#decrease_quantity', as: 'decrease_quantity'
  end

  resources :carts, only: [:show, :destroy]
  root 'store#index', as: 'store_index'
  resources :products
end
