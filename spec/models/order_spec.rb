require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "associations" do
    it { should belong_to(:table).optional }
    it { should belong_to(:user).with_foreign_key("user_cpf").with_primary_key("cpf") }
    it { should have_many(:order_lots).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }
  end

  describe "callbacks" do
    let!(:user) { FactoryBot.create(:user, cpf: "12345678900", password: "123456", is_admin: true) }
    let!(:product) { create(:product) }
    let!(:lot) { create(:lot, product: product, quantity: 10) }
    let!(:order_lot) { create(:order_lot, lot: lot, order: order, quantity: 1) }
    let!(:order) { FactoryBot.create(:order, user_cpf: user.cpf) }

    it "broadcasts orders update after create" do
      expect(ActionCable.server).to receive(:broadcast).with("dashboard_channel_orders", { refresh: true })
      order.run_callbacks(:create)
    end

    it "broadcasts stock update after update" do
      allow(Dashboards::Stock).to receive_message_chain(:new, :call, :result).and_return({ stock: "updated" })
      expect(ActionCable.server).to receive(:broadcast).with("dashboard_channel_stock", { stock: "updated" })
      order.run_callbacks(:update)
    end

    it "broadcasts orders update after update" do
      expect(ActionCable.server).to receive(:broadcast).with("dashboard_channel_orders", { refresh: true })
      order.run_callbacks(:update)
    end

    it "broadcasts orders update after destroy" do
      expect(ActionCable.server).to receive(:broadcast).with("dashboard_channel_orders", { refresh: true })
      order.run_callbacks(:destroy)
    end
  end
end
