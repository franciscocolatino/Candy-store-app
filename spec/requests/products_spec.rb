# spec/requests/products_spec.rb
require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let!(:user) { create(:user, is_admin: true) }
  let(:token) { JsonWebToken.encode(cpf: user.cpf) }
  let(:headers) { { 'Accept' => 'application/json' } }

  before do
    cookies[:auth_token] = token
  end

  describe 'GET /products' do
    let!(:products) { create_list(:product, 3) }

    it 'returns all products' do
      get products_path, headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
      expect(json.map { |p| p['id'] }).to match_array(products.map(&:id))
      expect(json.map { |p| p['name'] }).to match_array(products.map(&:name))
    end
  end

  describe 'POST /products' do
    let(:valid_attributes) { attributes_for(:product) }

    it 'creates a new product' do
      post products_path, params: { product: valid_attributes }, headers: headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['name']).to eq(valid_attributes[:name])
      expect(json['price'].to_f).to eq(valid_attributes[:price].to_f)
    end
  end

  describe 'PUT /products/:id' do
    let!(:product) { create(:product) }
    let(:new_attributes) { { name: 'Updated Product', price: 99.99 } }

    it 'updates the product' do
      put product_path(product), params: { product: new_attributes }, headers: headers

      expect(response).to have_http_status(:ok)
      product.reload
      json = JSON.parse(response.body)
      expect(product.name).to eq('Updated Product')
      expect(product.price).to eq(99.99)
      expect(json['name']).to eq('Updated Product')
      expect(json['price']).to eq('99.99')
    end
  end

  describe 'DELETE /products/:id' do
    let!(:product) { create(:product) }

    it 'deletes the product' do
      delete product_path(product), headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("#{product.name} deleted")
    end
  end
end
