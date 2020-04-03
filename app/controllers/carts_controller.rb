class CartsController < ApplicationController
  include CurrentCart
  skip_before_action :authorize, only: [:create, :update, :destroy]
  before_action :set_cart, only: [:show, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    @cart = nil
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to store_index_url, notice: 'Your cart is currently empty' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_index_url, notice: 'Invalid cart'
    end
end
