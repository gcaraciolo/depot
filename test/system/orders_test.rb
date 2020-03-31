require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
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
