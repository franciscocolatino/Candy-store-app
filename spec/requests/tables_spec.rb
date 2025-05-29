# spec/requests/tables_spec.rb
require 'rails_helper'

RSpec.describe 'Tables API', type: :request do
  let!(:admin_user) { create(:user, is_admin: true) }
  let!(:normal_user) { create(:user, is_admin: false) }
  let(:token) { JsonWebToken.encode(cpf: current_user.cpf) }
  let(:headers) { { 'Accept' => 'application/json', 'Authorization' => "Bearer #{token}" } }

  let(:current_user) { admin_user }

  before do
    cookies[:auth_token] = token
  end

  describe 'GET /tables' do
    let!(:tables) { create_list(:table, 3) }

    it 'returns all tables' do
      get tables_path, headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
      expect(json.map { |t| t['id'] }).to match_array(tables.map(&:id))
      expect(json.map { |t| t['number'] }).to match_array(tables.map(&:number))
    end
  end

  describe 'POST /tables' do
    let(:valid_attributes) { attributes_for(:table) }

    context 'when user is admin' do
      let(:current_user) { admin_user }

      it 'creates a new table' do
        post tables_path, params: { table: valid_attributes }, headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['number']).to eq(valid_attributes[:number])
      end
    end

    context 'when user is not admin' do
      let(:current_user) { normal_user }

      it 'returns unauthorized' do
        post tables_path, params: { table: valid_attributes }, headers: headers

        expect(response).to have_http_status(:unauthorized).or have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /tables/:id' do
    let(:current_user) { admin_user }
    let!(:table) { create(:table) }
    let!(:order) { create(:order, table: table, is_finished: false, user_cpf: current_user.cpf) }
    let!(:lot) { create(:lot) }
    let!(:order_lot) { create(:order_lot, order: order, lot: lot, quantity: 2) }

    it 'returns the table with current order and order lots' do
      get table_path(table), headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['table']['id']).to eq(table.id)
      expect(json['order']['id']).to eq(order.id)
      expect(json['order_lots']).to all(include('quantity', 'subtotal', 'product_name'))
    end
  end

  describe 'DELETE /tables/:id' do
    let(:current_user) { admin_user }
    let!(:table) { create(:table) }

    context 'when table has no orders' do
      it 'deletes the table' do
        delete table_path(table), headers: headers

        expect(response).to have_http_status(:found) # redireciona após delete
        expect(Table.exists?(table.id)).to be_falsey
      end
    end

    context 'when table has orders' do
      let!(:order) { create(:order, table: table, user_cpf: current_user.cpf) }

      it 'does not delete and redirects with alert' do
        delete table_path(table), headers: headers

        expect(response).to have_http_status(:found) # redireciona para show
        expect(Table.exists?(table.id)).to be_truthy
      end
    end
  end
end
