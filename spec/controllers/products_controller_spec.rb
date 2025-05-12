require 'rails_helper'
require 'api_helper'

RSpec.describe ProductsController, type: :controller do
  include ApiHelper

  let!(:product1) { FactoryBot.create(:product, name: "Product 1") }
  let!(:product2) { FactoryBot.create(:product, name: "Product 2") }
  let!(:user) { FactoryBot.create(:user, name: "teste", password: "123456") }
  let(:token) { generate_tokens(user, "123456") }

  before do
    cookies.encrypted[:auth_token] = token
    request.headers["Accept"] = "application/json"
  end

  describe "GET /products" do
    it "returns a list of products" do
      get :index, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Product 1")
      expect(response.body).to include("Product 2")
    end
  end

  describe "POST /products" do
    it "creates a product" do
      post :create, params: { product: { name: "Product 3", description: "desc", category: "cat", price: 10.0 } }, format: :json

      expect(response).to have_http_status(:created)
      expect(response.body).to include("Product 3")
    end
  end

  describe "PUT /products/:id" do
    it "updates a product" do
      put :update, params: { id: product1.id, product: { name: "Product 1 updated" } }, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Product 1 updated")
    end
  end

  describe "DELETE /products/:id" do
    it "deletes a product" do
      delete :destroy, params: { id: product1.id }, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Product 1 deleted")
    end
  end
end
