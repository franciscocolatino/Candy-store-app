class Product < ApplicationRecord
    has_many :lots, dependent: :destroy

    validates :name, uniqueness: { case_sensitive: false, message: "do produto ja esta em uso" }
    validates :name, presence: true
    validates :description, presence: true
    validates :category, presence: true
    validates :price, presence: true
end
