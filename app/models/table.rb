class Table < ApplicationRecord
    has_many :orders

    validates :number, presence: true, uniqueness: true

    has_many :orders

    def open_order
        orders.find_by(is_finished: false)
    end

    def occupied?
        open_order.present?
    end
end
