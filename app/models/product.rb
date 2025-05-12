class Product < ApplicationRecord
    has_many :lots, dependent: :destroy

    validates :name, presence: true
    validates :description, presence: true
    validates :category, presence: true
    validates :price, presence: true
end
