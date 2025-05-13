class Lot < ApplicationRecord
    belongs_to :product

    validates :quantity, presence: true
    validates :expiration_date, presence: true
    validates :manufacturing_date, presence: true
end
