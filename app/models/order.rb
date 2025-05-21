class Order < ApplicationRecord
    belongs_to :table, optional: true
    belongs_to :user, foreign_key: 'user_cpf', primary_key: 'cpf'

    validates :total_price, numericality: {greater_than_or_equal_to: 0}
end
