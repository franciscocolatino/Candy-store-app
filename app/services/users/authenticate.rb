class Users::Authenticate
  prepend SimpleCommand

  def initialize(attributes)
    @username = attributes[:username]
    @password = attributes[:password_digest]
  end

  def call
    user = authenticate_user
    return unless user

    token = JsonWebToken.encode(user_id: user.id)

    { token:, user: }
  end

  private

  def authenticate_user
    user = ::User.find_by_username(@username)
    return errors.add :user_authentication, 'invalid credentials' unless user&.authenticate(@password)

    user
  end
end