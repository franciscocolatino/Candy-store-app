module ApiHelper
  def generate_tokens(user, password)
    service = Users::Authenticate.call(
      cpf: user.cpf, password_digest: password
    )
    service.result[:token]
  end

  def auth_request(user)
    sign_in user
    user.create_new_auth_token
  end

  def transform_keys_to_camelcase(hash)
    new_hash = {}

    hash.each do |key, value|
      new_hash[key.to_s.camelize(:lower)] = value
    end
    new_hash
  end
end
