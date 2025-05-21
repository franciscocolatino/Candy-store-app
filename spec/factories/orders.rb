FactoryBot.define do
  factory :order do
    total_price { 1.5 }
    is_finished { false }
    date { "2025-05-20 13:40:58" }
  end
end
