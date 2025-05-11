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
end
