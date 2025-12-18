module Live
  class TodoList < LiveCable::Component
    reactive :todos, -> { [] }, shared: true
    reactive :filter, -> { :all }
    actions :randomize, :filter_all, :filter_active, :filter_completed

    def randomize
      todos.shuffle!
    end

    def filter_all
      self.filter = :all
    end

    def filter_active
      self.filter = :active
    end

    def filter_completed
      self.filter = :completed
    end

    def filtered_todos
      case filter
      when :active
        todos.select { |todo| !todo[:completed] }
      when :completed
        todos.select do |todo|
          todo[:completed]
        end
      else
        todos
      end
    end

    def total_count
      todos.length
    end

    def completed_count
      todos.count { |todo| todo[:completed] }
    end

    def remaining_count
      total_count - completed_count
    end

    def completion_percentage
      return 0 if total_count.zero?
      ((completed_count.to_f / total_count) * 100).round
    end
  end
end
