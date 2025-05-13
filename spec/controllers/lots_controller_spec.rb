require 'rails_helper'
require 'api_helper'

RSpec.describe LotsController, type: :controller do
  include ApiHelper

  let!(:product1) { FactoryBot.create(:product, name: "Product 1") }
  let!(:product2) { FactoryBot.create(:product, name: "Product 2") }
  let!(:user) { FactoryBot.create(:user, name: "teste", password: "123456") }
  let(:token) { generate_tokens(user, "123456") }

  before do
    cookies.encrypted[:auth_token] = token
    request.headers["Accept"] = "application/json"
  end

  describe "GET /lots" do
    it "returns a list of lots" do
      lot1 = FactoryBot.create(:lot, product: product1, quantity: 10)
      lot2 = FactoryBot.create(:lot, product: product1, quantity: 20)
  
      get :index, params: { product_id: product1.id }, format: :json
  
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("10")
      expect(response.body).to include("20")
    end
  end

  describe "POST /lots" do
    it "creates a lot" do
      post :create, params: { product_id: product1.id, lot: { quantity: 10, expiration_date: "2022-01-01", manufacturing_date: "2022-01-01" } }, format: :json

      expect(response).to have_http_status(:created)
      expect(response.body).to include("10")
    end
  end

  describe "GET /lots/:id" do
    it "returns a lot" do
      lot = FactoryBot.create(:lot, product: product1, quantity: 10)
  
      get :show, params: { product_id: product1.id, id: lot.id }, format: :json
  
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("10")
    end
  end

  describe "PUT /lots/:id" do
    it "updates a lot" do
      lot = FactoryBot.create(:lot, product: product1, quantity: 10)
  
      put :update, params: { product_id: product1.id, id: lot.id, lot: { quantity: 20 } }, format: :json
  
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("20")
    end
  end

  describe "DELETE /lots/:id" do
    it "deletes a lot" do
      lot = FactoryBot.create(:lot, product: product1, quantity: 10)
  
      delete :destroy, params: { product_id: product1.id, id: lot.id }, format: :json
  
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Lot deleted")
    end
  end


end