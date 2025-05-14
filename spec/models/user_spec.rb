require 'rails_helper'

RSpec.describe User, type: :model do
  it "should be valid with valid attributes" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "should not be valid without a name" do
    user = FactoryBot.build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it "should not be valid without a password" do
    user = FactoryBot.build(:user, password: nil)
    expect(user).not_to be_valid
  end

  context "CPF validation" do
    it "should be valid with a CPF of 11 digits" do
      user = FactoryBot.build(:user, cpf: "12345678901")
      expect(user).to be_valid
    end

    it "should not be valid with a CPF shorter than 11 digits" do
      user = FactoryBot.build(:user, cpf: "123456789")
      expect(user).not_to be_valid
      expect(user.errors[:cpf]).to include("inválido")
    end

    it "should not be valid with a CPF longer than 11 digits" do
      user = FactoryBot.build(:user, cpf: "123456789012")
      expect(user).not_to be_valid
      expect(user.errors[:cpf]).to include("inválido")
    end
  end
end
