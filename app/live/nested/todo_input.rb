module Live
  module Nested
    class TodoInput < LiveCable::Component
      shared :todos, -> { {} }

      reactive :text
      actions :add

      def add(params)
        return if params[:text].blank?

        id = SecureRandom.uuid
        self.todos = todos.merge(
          id => { id: id, text: params[:text], completed: false },
        )

        self.text = ""
      end
    end
  end
end
