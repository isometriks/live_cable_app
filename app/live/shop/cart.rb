module Live
  module Shop
    class Cart < LiveCable::Component
      shared :cart_items, -> { {} }

      actions :increase_quantity, :decrease_quantity, :remove_item, :clear_cart

      def increase_quantity(params)
        product_id = params[:product_id].to_i
        cart_items[product_id][:quantity] += 1 if cart_items[product_id]
      end

      def decrease_quantity(params)
        product_id = params[:product_id].to_i
        item = cart_items[product_id]
        return unless item

        if item[:quantity] > 1
          item[:quantity] -= 1
        else
          remove_item(params)
        end
      end

      def remove_item(params)
        product_id = params[:product_id].to_i
        cart_items.delete(product_id)
      end

      def clear_cart
        cart_items.clear
      end

      def cart_items_array
        cart_items.values
      end

      def subtotal
        cart_items.values.sum { |item| item[:price] * item[:quantity] }
      end

      def tax
        subtotal * 0.08
      end

      def total
        subtotal + tax
      end

      def item_count
        cart_items.values.sum { |item| item[:quantity] }
      end
    end
  end
end
