module Live
  module Todo
    class Hello < LiveCable::Component
      reactive :count, -> { 0 }

      actions :add

      def add
        self.count += 1
      end
    end
  end
end
