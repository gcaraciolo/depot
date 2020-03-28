require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!

    assert_select 'h2', 'Your Pragmatic Cart'
    assert_select 'td', "Programming Ruby 1.9"
  end

  # um teste melhor não seria verificando o HTML da página final?
  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    end

    assert_response :success
    assert_match /<tr class=\\"line-item-highlight/, @response.body
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to store_index_url
  end

  test "should decrease line_item quantity" do
    assert_difference -> { LineItem.find(@line_item.id).quantity }, -1 do
      post line_item_decrease_quantity_path(@line_item)
    end

    assert_redirected_to store_index_url
  end

  test "should remove cart when line_items are empty via ajax" do
    assert_difference -> { LineItem.find(@line_item.id).quantity }, -1 do
      post line_item_decrease_quantity_path(@line_item), xhr: true
    end

    assert_match /innerHTML = '';/, @response.body
  end

  test "should decrease line_item quantity via ajax" do
    post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    post line_items_url, params: { product_id: products(:ruby).id }, xhr: true

    assert_match /"quantity\\\">2/, @response.body
    cart = Cart.find(session[:cart_id])
    post line_item_decrease_quantity_path(cart.line_items.first), xhr: true

    assert_match /"quantity\\\">1/, @response.body
  end
end
