# spec/requests/sessions_spec.rb
require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456") }

  describe "GET /login" do
    it "renders the login page" do
      get login_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Login")
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "sets the auth token and redirects to root" do
        post login_path, params: { cpf: user.cpf, password_digest: "123456" }

        expect(response).to redirect_to(root_path)
        expect(response.cookies['auth_token']).to be_present
      end
    end

    context "with invalid credentials" do
      it "renders login again with error" do
        post login_path, params: { cpf: user.cpf, password_digest: "wrongpass" }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("Usuário ou senha inválidos")
      end
    end
  end

  describe "GET /logout" do
    it "clears the auth_token and redirects to login" do
      cookies['auth_token'] = 'some_token'

      get logout_path

      expect(response.cookies['auth_token']).to be_nil
      expect(response).to redirect_to(login_path)
    end
  end
end
