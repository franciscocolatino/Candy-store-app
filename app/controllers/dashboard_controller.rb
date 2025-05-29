class DashboardController < ApplicationController
  def show
    return render :index unless request.xhr? || request.format.json?

    case params[:type]
    when "orders"
      report = Dashboards::Orders.new(report_params).call
    when "stock"
      report = Dashboards::Stock.new.call
    else
      return render json: { error: "Tipo de relatório inválido" }, status: :bad_request
    end

    # Notifica o front-end via Action Cable
    # ActionCable.server.broadcast("dashboard_channel", {
    #   type: params[:type],
    #   payload: report
    # })

    render json: report
  end

  private

  def report_params
    params.permit(:type, :start_date, :end_date, :is_finished, :min_total, :max_total)
  end
end
