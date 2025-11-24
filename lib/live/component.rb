module Live
  class Component
    class_attribute :reactive_variables
    class_attribute :shared_reactive_variables

    def self.reactive(variable, initial_value = nil, shared: false)
      self.reactive_variables ||= []
      self.shared_reactive_variables ||= []

      if shared
        self.shared_reactive_variables << variable
      else
        self.reactive_variables << variable
      end

      define_method(variable) do
        container_name = shared ? Connection::SHARED_CONTAINER : _live_id

        _live_connection.get(container_name, variable, initial_value)
      end

      define_method("#{variable}=") do |value|
        container_name = shared ? Connection::SHARED_CONTAINER : _live_id

        _live_connection.set(container_name, variable, value)
      end
    end

    def broadcast(data)
      _live_connection.broadcast(data.merge('_id' => _live_id))
    end

    def render
      locals = (self.class.reactive_variables + self.class.shared_reactive_variables).map { |v| [v, send(v)] }.to_h

      ActionController::Base.render(
        partial: to_partial_path,
        locals:,
      )
    end

    def render_broadcast
      broadcast('_refresh': render)
    end

    def _defaults=(defaults)
      defaults = (defaults || {}).symbolize_keys
      keys = (self.class.reactive_variables + self.class.shared_reactive_variables) & defaults.keys

      keys.each do |key|
        public_send("#{key}=", defaults[key])
      end
    end

    def _live_connection=(connection)
      @_live_connection = connection
    end

    def _live_id=(_live_id)
      @_live_id = _live_id
    end

    def _live_id
      @_live_id
    end

    def to_partial_path
      "live/#{self.class.name.underscore}"
    end

    private

    attr_reader :_live_connection
  end
end
