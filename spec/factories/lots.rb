FactoryBot.define do
  factory :lot do
    association :product

    manufacturing_date { Date.yesterday }
    expiration_date { Date.today + 30.days }
    quantity { Faker::Number.number(digits: 2) }

    trait :expired do
      expiration_date { Date.yesterday }
      manufacturing_date { Date.yesterday - 7.days }
    end
  end
end
