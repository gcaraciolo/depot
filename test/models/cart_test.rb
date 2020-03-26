require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:freds_cart)
  end

  test "add a different product should add line_items" do 
    assert_equal 0, @cart.line_items.size

    add_product_to_cart(products(:ruby))
    assert_equal 1, @cart.line_items.size

    add_product_to_cart(products(:docker_rails))
    assert_equal 2, @cart.line_items.size
  end

  test "add same product should not add line_items" do
    add_product_to_cart(products(:docker_rails))
    add_product_to_cart(products(:docker_rails))

    assert_equal 1, @cart.line_items.size
    assert_equal 2, @cart.line_items.first.quantity
  end

  test "calculate cart total price" do
    add_product_to_cart(products(:ruby))
    assert_equal 49.50, @cart.total_price

    add_product_to_cart(products(:chatbot))
    assert_equal 49.50 + 20, @cart.total_price

    add_product_to_cart(products(:chatbot))
    assert_equal 49.50 + 20 + 20, @cart.total_price
  end

  private

  def add_product_to_cart(product)
    line_item = @cart.add_product(product)
    line_item.save!
    @cart.reload
  end
end
