FactoryBot.define do
  factory :order_lot do
    quantity { 1 }
    is_delivered { false }
    subtotal { 1.5 }
    order { nil }
    lot { nil }
  end
end
