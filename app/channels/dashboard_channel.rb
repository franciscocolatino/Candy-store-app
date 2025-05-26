class DashboardChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "dashboard_channel"
    transmit({ 
      type: "connection_established", 
      message: "Você está conectado ao canal do dashboard!",
      timestamp: Time.current
    })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
