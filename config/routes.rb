Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users

  resources :products do
    get :who_bought, on: :member
  end

  scope '(:locale)' do
    resources :orders
    
    resources :line_items do
      post 'decrease-quantity', on: :member
    end
    
    resources :carts, only: [:show, :destroy]

    root 'store#index', as: 'store_index', via: :all
  end
end
