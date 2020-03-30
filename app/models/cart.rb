class Cart < ApplicationRecord
    has_many :line_items, dependent: :destroy

    def add_product(product)
        current_item = line_items.find_by(product_id: product.id)
        if current_item
            current_item.quantity += 1
        else
            current_item = line_items.build(
                product_id: product.id,
                price: product.price
            )
        end
        current_item
    end

    ## pesquisar sobre chamadas save/update/create/destroy dentro de models.
    ## aparentemente, a indicação é usar operações
    ## em coleções do modelo
    ## e fora do método, chamar save/update/create/delete/destroy
    def remove_product(line_item)
        changelog = {
            quantity: line_item.quantity - 1
        }

        if changelog[:quantity] <= 0
            line_item.destroy!
        else
            line_item.update!(changelog)
        end
    end

    def total_price
        line_items.to_a.sum { |li| li.total_price }.to_f
    end
end
