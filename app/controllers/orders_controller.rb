class OrdersController < ApplicationController

    def create
       @order = Order.create(table_id: params[:table_id], user_cpf: @current_user.cpf)

      if @order.persisted?
        redirect_back(fallback_location: root_path, notice: "Pedido ##{@order.id} criado!")
      else
        redirect_back(fallback_location: root_path, alert: "Erro: #{@order.errors.full_messages.join(', ')}")
      end
  end

    def close_order
      @order = Order.find(params[:id])
      if @order.order_lots.all? { |lot| lot.is_delivered == true }
        @order.update(is_finished: true)
        redirect_to tables_path, notice: 'Pedido fechado com sucesso!'
      else
        redirect_to table_path(@order.table), notice: 'Ainda existem pedidos que nao foram entregues!'
      end
    end

    def destroy
    end
end
