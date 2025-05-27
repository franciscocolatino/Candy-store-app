class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :close_order, :destroy]

  def index
    @orders = Order.includes(:table, :order_lots => {:lot => :product})
                  .order(created_at: :desc)
    
    @orders = @orders.where(is_finished: params[:status] == 'finished') if params[:status] == 'finished'  
    @orders = @orders.where(is_finished: params[:status] == 'pending') if params[:status] == 'pending'  

    @orders = @orders.where(table_id: params[:table_id]) if params[:table_id].present?
    @orders = @orders.where(created_at: params[:start_date]..params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    
    @tables = Table.all.order(:number)
  end

    def create
       @order = Order.create(table_id: params[:table_id], user_cpf: @current_user.cpf)

      if @order.persisted?
        redirect_back(fallback_location: root_path, notice: "Pedido ##{@order.id} criado!")
      else
        redirect_back(fallback_location: root_path, alert: "Erro: #{@order.errors.full_messages.join(', ')}")
      end
  end

    def show
      @order_lots = @order.order_lots.includes(:lot => :product)
      @total = @order_lots.sum { |ol| ol.quantity * ol.lot.product.price }
    end

    def close_order
      if @order.order_lots.all? { |lot| lot.is_delivered == true } and @order.order_lots.any?
        @order.update(is_finished: true)
        @order.update(total_price: @order.order_lots.sum { |ol| ol.quantity * ol.lot.product.price })
        redirect_to order_path(@order), notice: 'Pedido fechado com sucesso!'
      else
        redirect_to order_path(@order), alert: 'Ainda existem itens que não foram entregues!'
      end
    end

    def destroy
      table=@order.table
      @order.destroy
      redirect_to table_path(table), notice: 'Pedido Cancelado com sucesso!'
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end
end
