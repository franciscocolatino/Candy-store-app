class Users::Authenticate
  prepend SimpleCommand

  def initialize(attributes)
    @cpf = attributes[:cpf]
    @password = attributes[:password_digest]
  end

  def call
    user = authenticate_user
    return unless user

    token = JsonWebToken.encode(cpf: user.cpf)

    { token:, user: }
  end

  private

  def authenticate_user
    user = ::User.find_by_cpf(@cpf)
    return errors.add :user_authentication, 'invalid credentials' unless user&.authenticate(@password)

    user
  end
end