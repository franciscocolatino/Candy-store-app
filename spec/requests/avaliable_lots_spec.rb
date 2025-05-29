require 'rails_helper'

RSpec.describe "AvaliableLots", type: :request do

  let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", is_admin: true) }
  let!(:table) { create(:table) }
  let!(:product) { create(:product) }
  let!(:lot) { create(:lot, product: product, quantity: 10) }
  let!(:order) { create(:order, table: table, user: user) }
  let!(:order_lot) { create(:order_lot, lot: lot, order: order, quantity: 1) }
  let!(:valid_headers) { { 'ACCEPT' => 'application/json' } }

  before do
    cookies[:auth_token] = JsonWebToken.encode(cpf: user.cpf)
  end

  describe "GET /index" do
    context 'when there are available lots' do
      let!(:available_lot) { create(:lot, product: product, quantity: 10) }
      let!(:unavailable_lot) { create(:lot, product: product, quantity: 0) }

      it 'returns http success for HTML format' do
        get avaliable_lots_path(order_id: order.id)
        expect(response).to have_http_status(:success)
      end

      it 'returns available lots in JSON format' do
        get avaliable_lots_path(order_id: order.id, format: :json)
        
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        
        # Verifica se o lote disponível está na resposta
        lot_ids = json_response.map { |lot| lot['id'] }
        expect(lot_ids).to include(available_lot.id)
        expect(lot_ids).not_to include(unavailable_lot.id)
      end
    end

    context 'when there are no available lots' do
      before do
        # Garante que não há lotes disponíveis
        Lot.update_all(quantity: 0)
      end

      it 'returns no content for JSON format' do
        get avaliable_lots_path(order_id: order.id, format: :json)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when order is not found' do
      it 'returns 404 not found' do
        get avaliable_lots_path(order_id: 999)
    
        expect(response).to have_http_status(:not_found)
      end
    end    
  end
end
