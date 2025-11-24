module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :live_connection
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      self.live_connection = LiveCable::Connection.new(request)
    end

    private

    # Demo-only: generates a fake user for each connection so the examples
    # work without requiring real authentication. In a real app you'd use
    # Devise/Warden and reject_unauthorized_connection for unauthenticated users.
    def find_verified_user
      if (verified_user = env['warden'].user)
        verified_user
      else
        User.build(
          id: SecureRandom.uuid,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
        )
      end
    end
  end
end
