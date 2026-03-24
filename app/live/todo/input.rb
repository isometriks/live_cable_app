module Live
  module Todo
    class Input < LiveCable::Component
      compound
      shared :todos, -> { [] }

      reactive :text
      reactive :loading, -> { true }
      actions :add

      after_connect -> do
        self.text = "whoa bro"
        self.loading = false
      end

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

      def template_state
        puts "Loading is #{self.loading.inspect}"
        puts live_connection&.send(:containers)&.inspect
        loading ? :loading : super
      end
    end
  end
end
