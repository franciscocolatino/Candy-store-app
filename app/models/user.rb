class User < ApplicationRecord
  self.primary_key = 'cpf'
  has_secure_password

  validates :cpf, presence: true
  validates :cpf, uniqueness: { message: "já cadastrado" }
end
