module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :live_connection
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      self.live_connection = LiveCable::Connection.new(request)
    end

    private

    def find_verified_user
      if (verified_user = env['warden'].user)
        verified_user
      else
        # Reject the connection if no verified user is found
        reject_unauthorized_connection
      end
    end
  end
end
