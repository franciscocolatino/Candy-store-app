class DashboardChannel < ApplicationCable::Channel
  def subscribed
    type = params[:type]
    Rails.logger.info "DashboardChannel subscribed with type: #{type}"
    Rails.logger.info "DashboardChannel subscribed with params: #{params.as_json}"

    stream_from "dashboard_channel_#{type}"
  end

  def unsubscribed
    Rails.logger.info "DashboardChannel unsubscribed"
  end


  def transmit_orders_with_filters(data)
    result = Dashboards::Orders.new(data).call.result
    transmit(result)
  end
end
