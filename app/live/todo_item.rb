module Live
  class TodoItem < LiveCable::Component
    shared :todos, -> { [] }
    reactive :todo

    actions :toggle, :remove

    def toggle(params)
      self.todo = todo.merge!(completed: !todo[:completed])
    end

    def remove(params)
      self.todos = todos.reject { _1[:id] == todo[:id] }
    end
  end
end
