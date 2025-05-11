FactoryBot.define do
  factory :user do
    cpf { "MyString" }
    name { "MyString" }
    password_digest { "MyString" }
    is_admin { false }
  end
end
