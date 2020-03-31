require "application_system_test_case"

class StoreTest < ApplicationSystemTestCase
    test "Add to cart reveals Cart" do
        visit store_index_url
    
        assert_no_selector "#cart > article"
    
        click_on 'Add to Cart', match: :first
    
        assert_selector "#cart > article"
    end
    
    test "Empty cart hide Cart" do
        visit store_index_url

        click_on 'Add to Cart', match: :first

        page.accept_confirm do
            click_on 'Empty cart'
        end

        assert_no_selector "#cart > article"
    end

    test "Add to cart highlight line item in Cart" do
        visit store_index_url

        click_on 'Add to Cart', match: :first

        assert_selector '#cart tr.line-item-highlight'
    end
end