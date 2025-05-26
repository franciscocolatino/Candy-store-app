class Dashboards::Orders
  prepend SimpleCommand  
  def initialize(params = {})
    @params = params
  end

  def call
    orders = Order.includes(order_lots: { lot: :product })

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

    {
      total_orders: orders.count,
      total_revenue: orders.sum(:total_price),
      average_order_value: orders.average(:total_price).to_f.round(2),
      orders_finished: orders.where(is_finished: true).count,
      orders_unfinished: orders.where(is_finished: false).count,
    }
  end
end
