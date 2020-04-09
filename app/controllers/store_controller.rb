class StoreController < ApplicationController
  include StoreVisitsCounter, CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      increment_store_visits_counter

      @products = Product.order(:title)
      @visits_count = store_visits_count
      @show_visits_count = @visits_count >= 5
    end
  end
end
