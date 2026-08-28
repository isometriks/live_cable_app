module Live
  module Chat
    class ChatRoom < LiveCable::Component
      after_connect :connected
      reactive :messages, -> { [] }, shared: true

      def connected
        stream_from("chat_messages", coder: ActiveSupport::JSON) do |data|
          messages << data

          # Fires on the client *after* the new message has been morphed in,
          # so the handler measures the right scroll height. Works the same
          # whether the message came from us or from another user.
          dispatch_event("chat:message-received", id: data["id"])
        end
      end
    end
  end
end
