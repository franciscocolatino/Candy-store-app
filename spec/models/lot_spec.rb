require 'rails_helper'

RSpec.describe Lot, type: :model do
  it "should be valid with valid attributes" do
    lot = FactoryBot.build(:lot)
    expect(lot).to be_valid
  end

  it "should not be valid without a product" do
    lot = FactoryBot.build(:lot, product: nil)
    expect(lot).not_to be_valid
  end

  it "should not be valid without a manufacturing_date" do
    lot = FactoryBot.build(:lot, manufacturing_date: nil)
    expect(lot).not_to be_valid
  end

  it "should not be valid without a expiration_date" do
    lot = FactoryBot.build(:lot, expiration_date: nil)
    expect(lot).not_to be_valid
  end

  it "should not be valid without a quantity" do
    lot = FactoryBot.build(:lot, quantity: nil)
    expect(lot).not_to be_valid
  end

  it "should expire if expiration_date is before today" do
    lot = FactoryBot.build(:lot, :expired)
    expect(lot.expiration_date).to be < Date.today
  end
end
