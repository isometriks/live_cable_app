module Live
  module Chat
    class ChatRoom < LiveCable::Component
      after_connect :connected
      reactive :messages, -> { [] }, shared: true

      def connected
        stream_from("chat_messages", coder: ActiveSupport::JSON) do |data|
          messages << data
        end
      end
    end
  end
end
