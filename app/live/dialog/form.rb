module Live
  module Dialog
    class Form < LiveCable::Component
      compound

      reactive :submitted, -> { false }

      shared :dialog, -> { Dialog.new("form-dialog") }
      actions :confirm

      def confirm
        dialog.confirmation = {
          title: "Is all of this information correct?",
          confirm: method(:confirm_dialog),
          cancel: method(:cancel_dialog)
        }
      end

      def confirm_dialog
        self.submitted = true
      end

      def cancel_dialog
        # noop
      end

      def variant
        submitted ? :submitted : super
      end
    end
  end
end
