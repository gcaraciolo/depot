class StoreController < ApplicationController
  include StoreVisitsCounter, CurrentCart
  before_action :set_cart

  def index
    increment_store_visits_counter

    @products = Product.order(:title)
    @visits_count = store_visits_count
    @show_visits_count = @visits_count >= 5
  end
end
