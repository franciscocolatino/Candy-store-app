require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  FactoryBot.create(:user, cpf: "12345678901", name: "User 1", password: "password")
  FactoryBot.create(:user, cpf: "12345678902", name: "User 2", password: "password")
  describe "GET /users" do
    it "returns a list of users" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("User 1")
      expect(response.body).to include("User 2")
    end
  end
end
