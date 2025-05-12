require 'rails_helper'
require 'api_helper'
RSpec.describe SessionsController, type: :controller do
  include ApiHelper

  let!(:user1) { FactoryBot.create(:user, name: "User 1", cpf: "12345678901", password: "123456") }

  describe "GET /login" do
    it "returns a token" do
      post :login, params: { cpf: user1.cpf, password_digest: "123456"} 
      
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(root_path)
    end
  end
end