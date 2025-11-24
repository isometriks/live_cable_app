module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :live_connection

    def connect
      self.live_connection = Live::Connection.new
    end
  end
end
