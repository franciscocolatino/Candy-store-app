FactoryBot.define do
  factory :product do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    category { Faker::Food.spice }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }

    deleted_at { nil }
  end
end
