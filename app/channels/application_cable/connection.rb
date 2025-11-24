module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :live_connection

    def connect
      self.live_connection = LiveCable::Connection.new
      puts "\n=== SETTING LIVE CONNECTION: #{live_connection.object_id}\n"
    end
  end
end
