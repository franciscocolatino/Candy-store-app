class Table < ApplicationRecord

    validates :number, presence: true, uniqueness: true
end
