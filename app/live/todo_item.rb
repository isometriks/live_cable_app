module Live
  class TodoItem < LiveCable::Component
    compound

    shared :todos, -> { [] }
    reactive :todo
    reactive :text, -> (component) { component.todo[:text] }
    reactive :state, -> { :component }

    actions :toggle, :remove, :edit, :save

    def toggle
      self.todo = todo.merge!(completed: !todo[:completed])
    end

    def remove
      self.todos = todos.reject { _1[:id] == todo[:id] }
    end

    def edit
      self.state = :edit
    end

    def save
      self.state = :component
      self.todo = todo.merge!(text:)
    end

    def template_state
      state
    end
  end
end
