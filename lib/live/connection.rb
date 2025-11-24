module Live
  class Connection
    attr_reader :session_id

    SHARED_CONTAINER = '_shared'

    def initialize
      @session_id = SecureRandom.uuid
      @containers = {}
      @components = {}
      @changeset = {}
    end

    def add_component(component)
      @components[component._live_id] = component
    end

    def get(container_name, variable, initial_value)
      @containers[container_name] ||= {}
      @containers[container_name][variable] ||= initial_value
    end

    def set(container_name, variable, value)
      has_value = @containers[container_name]&.key?(variable)
      current_value = @containers.dig(container_name, variable)

      if !has_value || current_value != value
        @changeset[container_name] ||= []
        @changeset[container_name] << variable
      end

      @containers[container_name] ||= {}
      @containers[container_name][variable] = value
    end

    def broadcast(data)
      ActionCable.server.broadcast(channel_name, data)
    end

    def receive(data)
      reset_changeset
      component = component_for_data(data)

      return unless component

      if data["_action"]
        component.public_send(data["_action"])
        broadcast_changeset
      end
    end

    def reactive(data)
      reset_changeset
      component = component_for_data(data)

      return unless component

      unless component.reactive_variables.include?(data["name"].to_sym)
        raise "Invalid reactive variable: #{data["name"]}"
      end

      component.public_send("#{data["name"]}=", data["value"])
      broadcast_changeset
    end

    def channel_name
      "live_#{session_id}"
    end

    private

    def reset_changeset
      @changeset = {}
    end

    def broadcast_changeset
      @components.each do |id, component|
        if @changeset[component._live_id]
          component.render_broadcast

          next
        end

        shared_changeset = @changeset[SHARED_CONTAINER] || []

        if (component.shared_reactive_variables || []).intersect?(shared_changeset)
          component.render_broadcast
        end
      end
    end

    def component_for_data(data)
      return unless data['_live_id']

      @components[data['_live_id']]
    end
  end
end
