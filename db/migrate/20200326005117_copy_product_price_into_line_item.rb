class CopyProductPriceIntoLineItem < ActiveRecord::Migration[6.0]
  def up
    Cart.all.each do |cart|
      cart.line_items.each do |line_item|
        line_item.price = line_item.product.price
        line_item.save!
      end
    end
  end

  def down
    Cart.all.each do |cart|
      cart.line_items.each do |line_item|
        line_item.price = nil
        line_item.save!
      end
    end
  end
end
