require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "check routing number" do
    checkout_before_select_pay_type

    assert_no_selector "#order_routing_number"
    assert_no_selector "#order_account_number"

    select 'Check', from: 'Pay type'

    assert_selector "#order_routing_number"
    assert_selector "#order_account_number"
  end

  test "check card number" do
    checkout_before_select_pay_type

    assert_no_selector "#order_credit_card_number"
    assert_no_selector "#order_expiration_date"

    select 'Credit card', from: 'Pay type'

    assert_selector "#order_credit_card_number"
    assert_selector "#order_expiration_date"
  end

  test "checkout PO number" do
    checkout_before_select_pay_type

    assert_no_selector "#order_po_number"

    select 'Purchase order', from: 'Pay type'

    assert_selector "#order_po_number"
  end

  test "place order" do
    LineItem.delete_all
    Order.delete_all

    checkout_before_select_pay_type

    select 'Check', from: 'Pay type'
    fill_in "Routing #", with: '123456'
    fill_in "Account #", with: '897645'

    perform_enqueued_jobs do
      click_button "Place Order"
    end

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  private

  def checkout_before_select_pay_type
    visit store_index_url

    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'
  end
end
