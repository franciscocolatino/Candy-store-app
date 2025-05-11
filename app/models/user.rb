class User < ApplicationRecord
  self.primary_key = 'cpf'
  has_secure_password

  
  validates :name, presence: true
  validates :password, presence: true
  validates :cpf, presence: true, uniqueness: true
end
