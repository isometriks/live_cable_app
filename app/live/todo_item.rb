module Live
  class TodoItem < LiveCable::Component
    compound

    shared :todos, -> { [] }
    reactive :todo
    reactive :text
    reactive :state, -> { :component }

    actions :toggle, :remove, :edit, :save, :change_priority

    def toggle
      todo[:completed] = !todo[:completed]
    end

    def change_priority
      todo[:priority] = case todo[:priority]
                        when :low then :medium
                        when :medium then :high
                        when :high then :low
                        else :low
                        end
    end

    def remove
      todos.delete_if { _1[:id] == todo[:id] }
    end

    def edit
      self.text = todo[:text]
      self.state = :edit
    end

    def save(params)
      todo[:text] = params[:text]

      self.state = :component
    end

    def template_state
      state
    end
  end
end
