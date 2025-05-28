require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", name: "Fulano", is_admin: true) }

  before do
    cookies[:auth_token] = JsonWebToken.encode(cpf: user.cpf)
  end

  describe "GET /users" do
    it "returns a successful response" do
      get users_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.name)
    end
  end

  describe "GET /users/:id" do
    it "shows the user details" do
      get user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.name)
    end
  end

  describe "GET /users/new" do
    it "renders the new user form" do
      get new_user_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Cadastrar Usuário")
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      it "creates a new user and sets the auth token" do
        expect {
          post users_path, params: { user: { name: "Test User", cpf: "11122233344", password: "abc123" } }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(response.cookies['auth_token']).to be_present
      end
    end

    context "with invalid parameters" do
      it "does not create user and re-renders form" do
        expect {
          post users_path, params: { user: { name: "", cpf: "", password: "" } }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Cadastrar Usuário")
      end
    end
  end

  describe "GET /users/:id/edit" do
    it "renders the edit form" do
      get edit_user_path(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Editar Usuário")
    end
  end

  describe "PATCH /users/:id" do
    it "updates the user and redirects" do
      patch user_path(user), params: { user: { name: "Novo Nome" } }
      expect(response).to redirect_to(edit_user_path(user))
      follow_redirect!
      expect(flash[:notice]).to eq("Seu usuário foi atualizado com sucesso. Faça login novamente com o novo cpf.")
    end
  end

  describe "DELETE /users/:id" do
    it "deletes the user and redirects" do
      user_to_delete = FactoryBot.create(:user)
      delete user_path(user_to_delete)

      expect(response).to redirect_to(users_path)
      follow_redirect!
      expect(response.body).to include("Usuário foi destruído com sucesso")
    end
  end

  describe "PATCH /users/:id/update_password" do
    it "updates the password successfully" do
      patch password_update_path(user), params: {
        password: "newpassword", password_confirmation: "newpassword"
      }

      expect(response).to redirect_to(edit_user_path(user))
      follow_redirect!
      expect(response.body).to include("Senha atualizada com sucesso")
    end

    it "error when the password and confirmation do not match" do
      patch password_update_path(user), params: {
        password: "newpassword", password_confirmation: "wrongpassword"
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("As senhas não coincidem.")
    end
  end
end
