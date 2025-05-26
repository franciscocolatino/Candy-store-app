class OrderLot < ApplicationRecord
  belongs_to :order
  belongs_to :lot

  validates :quantity, numericality: {greater_than_or_equal_to: 1}

  before_destroy :restore_lot_quantity

  private
  
  def restore_lot_quantity
    lot.update!(quantity: lot.quantity + quantity)
  end
end
