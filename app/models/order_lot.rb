class OrderLot < ApplicationRecord
  belongs_to :order
  belongs_to :lot

  validates :subtotal, numericality: {greater_than_or_equal_to: 0}
  validates :subtotal, numericality: {greater_than_or_equal_to: 1}
end
