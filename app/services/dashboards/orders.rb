class Dashboards::Orders
  prepend SimpleCommand
  def initialize(params = {})
    @params = params
  end

  def call
    orders = Order.includes(order_lots: { lot: :product }).order(date: :desc)

    if @params[:start_date].present? && @params[:end_date].present?
      orders = orders.where(date: @params[:start_date]..@params[:end_date])
    end

    if @params[:is_finished].present?
      orders = orders.where(is_finished: ActiveModel::Type::Boolean.new.cast(@params[:is_finished]))
    end

    if @params[:min_total].present?
      orders = orders.where("total_price >= ?", @params[:min_total].to_f)
    end

    if @params[:max_total].present?
      orders = orders.where("total_price <= ?", @params[:max_total].to_f)
    end

    date_range = 30.days.ago.to_date..Date.current
    orders_by_date = orders.where(date: date_range)
      .group("date")
      .order("date")
      .count

    chart_data = date_range.each_with_object({}) { |date, hash| hash[date] = 0 }
    chart_data.merge!(orders_by_date)

    result = {
      summary: {
        total_orders: orders.count,
        total_revenue: orders.sum(:total_price),
        average_order_value: orders.average(:total_price).to_f.round(2),
        orders_finished: orders.where(is_finished: true).count,
        orders_unfinished: orders.where(is_finished: false).count
      },
      chart_data: {
        labels: chart_data.keys.map { |date| date.strftime("%d/%m") },
        values: chart_data.values
      },
      orders: orders.limit(50).map do |order|
        {
          id: order.id,
          date: order.date.strftime("%d/%m/%Y"),
          status: order.is_finished ? "Finalizado" : "Pendente",
          total: "R$ #{'%.2f' % order.total_price}".gsub(".", ",")
        }
      end
    }
  end
end
