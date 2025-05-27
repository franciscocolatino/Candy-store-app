class DashboardChannel < ApplicationCable::Channel
  def subscribed
    type = params[:type]
    Rails.logger.info "DashboardChannel subscribed with type: #{type}"

    stream_from "dashboard_channel_#{type}"
  end

  def unsubscribed
    Rails.logger.info "DashboardChannel unsubscribed"
  end
end
