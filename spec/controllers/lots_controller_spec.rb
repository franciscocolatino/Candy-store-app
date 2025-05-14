require 'rails_helper'
require 'api_helper'

RSpec.describe LotsController, type: :controller do
  include ApiHelper

  let!(:product1) { FactoryBot.create(:product, name: "Product 1") }
  let!(:user) { FactoryBot.create(:user, name: "teste", password: "123456") }
  let(:token) { generate_tokens(user, "123456") }

  before do
    cookies.encrypted[:auth_token] = token
  end

  describe "GET /lots" do
    it "returns a list of lots" do
      lot1 = FactoryBot.create(:lot, product: product1, quantity: 10)
      lot2 = FactoryBot.create(:lot, product: product1, quantity: 20)

      get :index, params: { product_id: product1.id }

      expect(response).to have_http_status(:ok)
      expect(Lot.count).to eq(2)
    end
  end

  describe "POST /lots" do
    it "creates a lot and redirects" do
      post :create, params: {
        product_id: product1.id,
        lot: {
          quantity: 10,
          expiration_date: "2022-01-01",
          manufacturing_date: "2022-01-01"
        }
      }

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(product_lots_path(product1))
      expect(flash[:notice]).to eq("Lote criado com sucesso.")
    end
  end

  describe "GET /lots/:id" do
    it "shows a lot" do
      lot = FactoryBot.create(:lot, product: product1, quantity: 10)

      get :show, params: { product_id: product1.id, id: lot.id }

      expect(response).to have_http_status(:ok)
      expect(Lot.count).to eq(1)
    end
  end

  describe "PUT /lots/:id" do
    it "updates a lot and redirects" do
      lot = FactoryBot.create(:lot, product: product1, quantity: 10)

      put :update, params: {
        product_id: product1.id,
        id: lot.id,
        lot: { quantity: 20 }
      }

      expect(response).to redirect_to(product_lots_path(product1))
      expect(flash[:notice]).to eq("Lote atualizado com sucesso.")
      lot.reload
      expect(lot.quantity).to eq(20)
    end
  end

  describe "DELETE /lots/:id" do
    it "deletes a lot and redirects" do
      lot = FactoryBot.create(:lot, product: product1, quantity: 10)

      delete :destroy, params: { product_id: product1.id, id: lot.id }

      expect(response).to redirect_to(product_lots_path(product1))
      expect(flash[:notice]).to eq("Lote removido com sucesso.")
      expect { lot.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
