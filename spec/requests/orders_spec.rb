require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", is_admin: true) }
  let!(:table) { FactoryBot.create(:table, number: 1) }
  let!(:order) { FactoryBot.create(:order, table: table, user_cpf: user.cpf) }

  before do
    cookies[:auth_token] = JsonWebToken.encode(cpf: user.cpf)
  end

  describe "GET /orders" do
    it "renders the list of orders" do
      get orders_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Pedidos").or include("Orders")
    end
  end

  describe "POST /orders" do
    it "creates a new order and redirects" do
      expect {
        post orders_path, params: { table_id: table.id }
      }.to change(Order, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Pedido").or include("criado")
    end
  end

  describe "GET /orders/:id" do
    it "shows the selected order" do
      get order_path(order)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Pedido").or include(order.id.to_s)
    end
  end

  describe "POST /orders/:id/close_order" do
    context "when all items are delivered" do
      let!(:product) { FactoryBot.create(:product) }
      let!(:lot) { FactoryBot.create(:lot, product: product) }
      let!(:order_lot) { FactoryBot.create(:order_lot, order: order, lot: lot, is_delivered: true) }

      it "closes the order and redirects" do
        post close_order_order_path(order)
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("Pedido fechado com sucesso")
      end
    end

    context "when there are undelivered items" do
      let!(:product) { FactoryBot.create(:product) }
      let!(:lot) { FactoryBot.create(:lot, product: product) }
      let!(:order_lot) { FactoryBot.create(:order_lot, order: order, lot: lot, is_delivered: false) }

      it "does not close the order and shows alert" do
        post close_order_order_path(order)
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include("Ainda existem itens que não foram entregues")
      end
    end
  end

  describe "DELETE /orders/:id" do
    it "deletes the order and redirects to table" do
      expect {
        delete order_path(order)
      }.to change(Order, :count).by(-1)

      expect(response).to redirect_to(table_path(table))
      follow_redirect!
      expect(response.body).to include("Pedido Cancelado com sucesso")
    end
  end
end
