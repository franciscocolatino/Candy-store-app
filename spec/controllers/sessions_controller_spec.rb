require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456") }

  describe "POST /login" do
    it "returns a token and redirects to root_path" do
      post :login, params: { cpf: user.cpf, password_digest: "123456" }

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(root_path)

      token = cookies.encrypted[:auth_token]
      expect(token).to be_present
    end
  end
end
