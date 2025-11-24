class LiveChannel < ApplicationCable::Channel
  def subscribed
    # @todo - Add a stream for each component
    stream_from(live_connection.channel_name)

    instance = HelloWorld.new
    instance._live_id = params[:_live_id]
    instance._live_connection = live_connection
    instance._defaults = params[:defaults]

    live_connection.add_component(instance)

    instance.broadcast({ _status: "subscribed" })
    instance.render_broadcast
  end

  def receive(data)
    live_connection.receive(data)
  end

  def reactive(data)
    live_connection.reactive(data)
  end
end
