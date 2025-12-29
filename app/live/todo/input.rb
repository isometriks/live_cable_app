module Live
  module Todo
    class Input < LiveCable::Component
      shared :todos, -> { [] }

      reactive :text
      actions :add

      def add(params)
        return if params[:text].blank?

        todos << {
          id: SecureRandom.uuid,
          text: params[:text],
          completed: false,
          priority: :low,
        }

        self.text = ""
      end
    end
  end
end
