module Live
  class TodoList < LiveCable::Component
    reactive :todos, -> { [] }, shared: true
    actions :randomize

    def randomize
      self.todos = todos.shuffle
    end
  end
end
