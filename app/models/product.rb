class Product < ApplicationRecord
    has_many :lots, dependent: :destroy
end
