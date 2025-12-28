module Live
  module Dialog
    class Dialog < LiveCable::Component
      reactive :confirmation
      actions :confirm, :cancel

      def confirm
        confirmation[:confirm].call

        self.confirmation = nil
      end

      def cancel
        confirmation[:cancel].call

        self.confirmation = nil
      end
    end
  end
end
