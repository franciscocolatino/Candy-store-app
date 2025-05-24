class User < ApplicationRecord
  self.primary_key = "cpf"
  has_secure_password

  has_many :orders, foreign_key: 'user_cpf'
  
  validates :name, presence: true
  validates :password, presence: true, if: :password_required?
  validates :cpf, presence: true
  validates :cpf, uniqueness: { message: "já cadastrado" }
  validates :cpf, length: { is: 11, message: "inválido" }

  private

  def password_required?
    new_record? || password.present?
  end
end
