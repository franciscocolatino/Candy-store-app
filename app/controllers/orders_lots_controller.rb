class OrdersLotsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])

    OrderLot.transaction do
      params[:order_lots].each do |lot_params|
        permitted = lot_params.permit(:lot_id, :quantity)
        lot_id = permitted[:lot_id]
        quantity = permitted[:quantity].to_i

        order_lot = @order.order_lots.find_by(lot_id: lot_id)
        if order_lot
            order_lot.increment!(:quantity, quantity)
        else
            @order.order_lots.create!(lot_id: lot_id, quantity: quantity)
        end

        lot= Lot.find(lot_id)
        new_quantity = lot.quantity - quantity
        if new_quantity < 0
            raise ActiveRecord::Rollback, "Quantidade insuficiente no lote #{lot.id}"
        end
        lot.update!(quantity: new_quantity)
        @order.update(total_price: @order.order_lots.includes(lot: :product).sum { |ol| ol.quantity * ol.lot.product.price })
      end
    end

    redirect_to @order, notice: "itens adicionados com sucesso!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to order_avaliable_lots_path(@order), alert: "Erro ao adicionar itens"
  end


  def destroy
    @order = Order.find(params[:order_id])

    order_id, lot_id = params[:id].split("_")

    # Encontra o registro usando a chave composta
    @order_lot = OrderLot.find_by!(order_id: order_id, lot_id: lot_id)

    @order_lot.destroy
    @order.update(total_price: @order.order_lots.includes(lot: :product).sum { |ol| ol.quantity * ol.lot.product.price })

    redirect_to @order, notice: "Item removido com sucesso."
  end

  def order_lot_delivered
    @order = Order.find(params[:order_id])

    order_id, lot_id = params[:id].split("_")

    # Encontra o registro usando a chave composta
    order_lot = OrderLot.find_by!(order_id: order_id, lot_id: lot_id)
    unless order_lot
      redirect_to @order.table, alert: "Lote não encontrado!"
      return
    end

    bool  = true
    if order_lot.is_delivered
      bool= false
    end
    order_lot.update!(is_delivered: bool)

    redirect_to @order
  end
end
