module Live
  module Shop
    class ProductGrid < LiveCable::Component
      shared :cart_items, -> { {} }
      reactive :current_page, -> { 1 }
      reactive :dialog, -> { Dialog::Dialog.new("cart-dialog", confirmation: { title: "Hey?", confirm: -> { puts "Works" }, cancel: -> { puts "Nope"} }) }

      actions :add_to_cart, :next_page, :prev_page, :go_to_page

      ITEMS_PER_PAGE = 8

      def add_to_cart(params)
        product_id = params[:product_id].to_i
        product = products[product_id]

        return unless product

        if cart_items[product_id]
          cart_items[product_id][:quantity] += 1
        else
          cart_items[product_id] = {
            product_id: product_id,
            name: product[:name],
            price: product[:price],
            quantity: 1
          }
        end
      end

      def next_page
        self.current_page = [current_page + 1, total_pages].min
      end

      def prev_page
        self.current_page = [current_page - 1, 1].max
      end

      def go_to_page(params)
        page = params[:page].to_i
        self.current_page = [[page, 1].max, total_pages].min
      end

      def products
        @products ||= {
          1 => { id: 1, name: "Wireless Headphones", price: 79.99, image: "🎧" },
          2 => { id: 2, name: "Smart Watch", price: 199.99, image: "⌚" },
          3 => { id: 3, name: "Laptop Stand", price: 49.99, image: "💻" },
          4 => { id: 4, name: "Mechanical Keyboard", price: 129.99, image: "⌨️" },
          5 => { id: 5, name: "USB-C Hub", price: 39.99, image: "🔌" },
          6 => { id: 6, name: "Webcam HD", price: 89.99, image: "📷" },
          7 => { id: 7, name: "Desk Lamp", price: 34.99, image: "💡" },
          8 => { id: 8, name: "Phone Stand", price: 24.99, image: "📱" },
          9 => { id: 9, name: "Bluetooth Speaker", price: 59.99, image: "🔊" },
          10 => { id: 10, name: "Wireless Mouse", price: 44.99, image: "🖱️" },
          11 => { id: 11, name: "Monitor 27\"", price: 299.99, image: "🖥️" },
          12 => { id: 12, name: "Ergonomic Chair", price: 349.99, image: "🪑" },
          13 => { id: 13, name: "External SSD 1TB", price: 119.99, image: "💾" },
          14 => { id: 14, name: "Graphics Tablet", price: 89.99, image: "🎨" },
          15 => { id: 15, name: "Microphone USB", price: 79.99, image: "🎤" },
          16 => { id: 16, name: "Cable Organizer", price: 19.99, image: "📦" },
          17 => { id: 17, name: "Laptop Sleeve", price: 29.99, image: "💼" },
          18 => { id: 18, name: "Portable Charger", price: 39.99, image: "🔋" },
          19 => { id: 19, name: "Wireless Earbuds", price: 99.99, image: "🎵" },
          20 => { id: 20, name: "Ring Light", price: 54.99, image: "💡" },
          21 => { id: 21, name: "Gaming Mouse Pad", price: 24.99, image: "🎮" },
          22 => { id: 22, name: "Thunderbolt Cable", price: 34.99, image: "⚡" },
          23 => { id: 23, name: "Document Scanner", price: 149.99, image: "📄" },
          24 => { id: 24, name: "Wrist Rest Pad", price: 14.99, image: "🤚" }
        }
      end

      def paginated_products
        start_index = (current_page - 1) * ITEMS_PER_PAGE
        products.values.slice(start_index, ITEMS_PER_PAGE) || []
      end

      def total_pages
        (products.size.to_f / ITEMS_PER_PAGE).ceil
      end
    end
  end
end
