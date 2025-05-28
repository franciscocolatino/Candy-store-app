require 'rails_helper'

RSpec.describe Table, type: :model do
  describe "associations" do
    it { should have_many(:orders) }
  end

  describe "validations" do
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number) }
  end

  describe "#open_order" do
    let(:table) { FactoryBot.create(:table) }
    let(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", is_admin: true) }
    let!(:finished_order) { FactoryBot.create(:order, table: table, is_finished: true, user_cpf: user.cpf) }
    let!(:open_order) { FactoryBot.create(:order, table: table, is_finished: false, user_cpf: user.cpf) }

    it "returns the open order if exists" do
      expect(table.open_order).to eq(open_order)
    end

    it "returns nil if there are no open orders" do
      open_order.update(is_finished: true)
      expect(table.open_order).to be_nil
    end
  end

  describe "#occupied?" do
    let(:table) { FactoryBot.create(:table) }
    let(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", is_admin: true) }

    context "when there is an open order" do
      before { FactoryBot.create(:order, table: table, is_finished: false, user_cpf: user.cpf) }

      it "returns true" do
        expect(table.occupied?).to be true
      end
    end

    context "when there is no open order" do
      it "returns false" do
        expect(table.occupied?).to be false
      end
    end
  end
end
