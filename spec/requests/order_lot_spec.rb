require 'rails_helper'

RSpec.describe "OrderLots", type: :request do
  let!(:product) { create(:product, price: 10.0) }
  let!(:lot) { create(:lot, product: product, quantity: 100) }
  let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", is_admin: true) }
  let!(:table) { create(:table) }
  let!(:order) { create(:order, table: table, user: user) }

  before do
    cookies[:auth_token] = JsonWebToken.encode(cpf: user.cpf)
  end

  describe "POST /orders/:order_id/order_lots" do
    context "with valid parameters" do
      it "adds a new order_lot and updates lot quantity and order total_price" do
        post order_orders_lots_path(order), params: {
          order_lots: [{ lot_id: lot.id, quantity: 5 }]
        }

        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("itens adicionados com sucesso!")

        order.reload
        expect(order.order_lots.count).to eq(1)
        expect(order.total_price).to eq(50.0)
        expect(lot.reload.quantity).to eq(95)
      end
    end

    context "when quantity exceeds lot stock" do
      it "does not create and shows error" do
        post order_orders_lots_path(order), params: {
          order_lots: [{ lot_id: lot.id, quantity: 999 }]
        }

        expect(response).to redirect_to(avaliable_lots_path(order_id: order.id))

        follow_redirect!
        expect(response.body).to include("Erro ao adicionar itens")
        expect(order.order_lots).to be_empty
        expect(lot.reload.quantity).to eq(100)
      end
    end
  end

  describe "DELETE /orders/:order_id/order_lots/:id" do
    it "removes the order_lot and updates the order total_price" do
      order_lot = create(:order_lot, order: order, lot: lot, quantity: 10)
      order.update(total_price: 100)

      delete order_orders_lot_path(order, "#{order.id}_#{lot.id}")

      expect(response).to redirect_to(order_path(order))
      follow_redirect!
      expect(response.body).to include("Item removido com sucesso.")

      expect(order.order_lots.count).to eq(0)
      expect(order.reload.total_price).to eq(0)
    end
  end

  describe "POST /orders/:order_id/order_lots/:id/delivered" do
    it "toggles the is_delivered flag" do
      order_lot = create(:order_lot, order: order, lot: lot, is_delivered: false)

      post order_lot_delivered_order_orders_lot_path(order, "#{order.id}_#{lot.id}")

      expect(response).to redirect_to(order_path(order))
      expect(order_lot.reload.is_delivered).to eq(true)

      post order_lot_delivered_order_orders_lot_path(order, "#{order.id}_#{lot.id}")


      expect(order_lot.reload.is_delivered).to eq(false)
    end
  end
end
