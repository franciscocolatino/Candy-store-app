require 'rails_helper'
require 'api_helper'
RSpec.describe UsersController, type: :controller do
  include ApiHelper

  let!(:user1) { FactoryBot.create(:user, name: "User 1", password: "123456") }
  let!(:user2) { FactoryBot.create(:user, name: "User 2", password: "123456") }

  let(:token) { generate_tokens(user1) }

  describe "GET /users" do
    it "returns a list of users" do
      get :index, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("User 1")
      expect(response.body).to include("User 2")
    end
  end
end
