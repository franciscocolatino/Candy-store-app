require 'rails_helper'

RSpec.describe OrderLot, type: :model do
  let(:product) { create(:product) }
  let(:lot) { create(:lot, product: product, quantity: 10) }
  let(:order) { create(:order, user_cpf: user.cpf)}
  let(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", is_admin: true) }
  
  subject { described_class.new(order: order, lot: lot, quantity: 3) }

  describe 'validations' do
    it 'is valid with quantity greater or equal to 1' do
      subject.quantity = 1
      expect(subject).to be_valid
    end

    it 'is invalid with quantity less than 1' do
      subject.quantity = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:quantity]).to include('deve ser maior ou igual a 1')
    end
  end

  describe 'callbacks' do
    it 'restores lot quantity before destroy' do
      subject.save!
      expect { subject.destroy }.to change { lot.reload.quantity }.by(subject.quantity)
    end
  end
end
