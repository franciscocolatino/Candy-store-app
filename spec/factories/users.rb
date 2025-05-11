FactoryBot.define do
  factory :user do
    cpf { Faker::Number.number(digits: 11).to_s }
    name { Faker::Name.name }
    password { "123456" }
    is_admin { false }
  end
end
