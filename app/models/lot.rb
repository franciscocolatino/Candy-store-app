class Lot < ApplicationRecord
    belongs_to :product

    validates :quantity, presence: true
    validates :expiration_date, presence: true
    validates :manufacturing_date, presence: true

    validate :verify_expiration_date

    has_many :order_lots

    after_update :broadcast_stock_update
    after_destroy :broadcast_stock_update
    after_create :broadcast_stock_update


    private

    def verify_expiration_date
      if expiration_date.present? && manufacturing_date.present? && expiration_date < manufacturing_date
        errors.add(:expiration_date, "não pode ser menor do que a data de fabricação")
      end
    end

    def broadcast_stock_update
      payload = Dashboards::Stock.new.call.result

      ActionCable.server.broadcast("dashboard_channel_stock", payload)
    end
end
