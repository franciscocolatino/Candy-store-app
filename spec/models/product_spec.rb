require 'rails_helper'

RSpec.describe Product, type: :model do
  it "should be valid with valid attributes" do
    product = FactoryBot.build(:product)
    expect(product).to be_valid
  end

  it "should not be valid without a name" do
    product = FactoryBot.build(:product, name: nil)
    expect(product).not_to be_valid
  end

  it "should not be valid without a description" do
    product = FactoryBot.build(:product, description: nil)
    expect(product).not_to be_valid
  end 

  it "should not be valid without a category" do
    product = FactoryBot.build(:product, category: nil)
    expect(product).not_to be_valid
  end

  it "should not be valid without a price" do
    product = FactoryBot.build(:product, price: nil)
    expect(product).not_to be_valid
  end
end
