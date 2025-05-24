class OrdersController < ApplicationController

    def create
       @order = Order.create(table_id: params[:table_id], user_cpf: @current_user.cpf)

      if @order.persisted?
        redirect_back(fallback_location: root_path, notice: "Pedido ##{@order.id} criado!")
      else
        redirect_back(fallback_location: root_path, alert: "Erro: #{@order.errors.full_messages.join(', ')}")
      end
  end
end
