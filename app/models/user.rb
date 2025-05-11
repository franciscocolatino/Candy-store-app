class User < ApplicationRecord
  self.primary_key = 'cpf'
  has_secure_password
end
