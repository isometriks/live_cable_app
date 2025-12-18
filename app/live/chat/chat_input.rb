module Live
  module Chat
    class ChatInput < LiveCable::Component
      reactive :message
      actions :send_message

      def send_message(params)
        return if params[:message].blank?

        message_data = {
          id: SecureRandom.uuid,
          text: params[:message],
          timestamp: Time.now.to_i,
          user: current_user.as_json(only:  [:id, :first_name, :last_name]),
        }

        # Broadcast to the chat stream
        ActionCable.server.broadcast("chat_messages", message_data)

        # Clear the input
        self.message = ""
      end
    end
  end
end
