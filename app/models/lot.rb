class Lot < ApplicationRecord
    belongs_to :product
  
    validates :quantity, presence: true
    validates :expiration_date, presence: true
    validates :manufacturing_date, presence: true
  
    validate :verify_expiration_date 

    has_many :order_lots

    private
  
    def verify_expiration_date
      if expiration_date.present? && manufacturing_date.present? && expiration_date < manufacturing_date
        errors.add(:expiration_date, "não pode ser menor do que a data de fabricação")
      end
    end
  end
  