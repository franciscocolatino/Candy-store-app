require 'rails_helper'

RSpec.describe "Lots", type: :request do
  let!(:product) { FactoryBot.create(:product, name: "Product 1") }
  let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456") }

  before do
    cookies[:auth_token] = JsonWebToken.encode(cpf: user.cpf)
  end

  describe "GET /products/:product_id/lots" do
    it "renders a list of lots" do
      FactoryBot.create(:lot, product: product, quantity: 10)
      FactoryBot.create(:lot, product: product, quantity: 20)

      get product_lots_path(product)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("10")
      expect(response.body).to include("20")
    end
  end

  describe "GET /products/:product_id/lots/:id" do
    it "shows the selected lot" do
      lot = FactoryBot.create(:lot, product: product, quantity: 15)

      get product_lot_path(product, lot)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("15")
    end
  end

  describe "GET /products/:product_id/lots/new" do
    it "renders the new lot form" do
      get new_product_lot_path(product)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Novo Lote").or include("Criar Lote")
    end
  end

  describe "POST /products/:product_id/lots" do
    context "with valid params" do
      it "creates a new lot and redirects" do
        expect {
          post product_lots_path(product), params: {
            lot: {
              quantity: 30,
              expiration_date: "2025-12-01",
              manufacturing_date: "2025-01-01"
            }
          }
        }.to change(Lot, :count).by(1)

        expect(response).to redirect_to(product_lots_path(product))
        follow_redirect!
        expect(response.body).to include("Lote criado com sucesso")
      end
    end

    context "with invalid params" do
      it "renders the form again" do
        post product_lots_path(product), params: {
          lot: { quantity: nil }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Novo Lote").or include("Criar Lote")
      end
    end
  end

  describe "GET /products/:product_id/lots/:id/edit" do
    it "renders the edit form" do
      lot = FactoryBot.create(:lot, product: product)

      get edit_product_lot_path(product, lot)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Editando").or include("Editar Lote")
    end
  end

  describe "PATCH /products/:product_id/lots/:id" do
    it "updates the lot and redirects" do
      lot = FactoryBot.create(:lot, product: product, quantity: 10)

      patch product_lot_path(product, lot), params: {
        lot: { quantity: 99 }
      }

      expect(response).to redirect_to(product_lots_path(product))
      follow_redirect!
      expect(response.body).to include("Lote atualizado com sucesso")
      lot.reload
      expect(lot.quantity).to eq(99)
    end
  end

  describe "DELETE /products/:product_id/lots/:id" do
    it "deletes the lot and redirects" do
      lot = FactoryBot.create(:lot, product: product)

      expect {
        delete product_lot_path(product, lot)
      }.to change(Lot, :count).by(-1)

      expect(response).to redirect_to(product_lots_path(product))
      follow_redirect!
      expect(response.body).to include("Lote removido com sucesso")
    end
  end
end
