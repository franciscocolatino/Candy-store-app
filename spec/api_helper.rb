module ApiHelper
  def generate_tokens_admin(admin)
    service = Users::Authenticate.call(admin.name, admin.password_digest)
    service.result[:token]
  end

  def generate_tokens(user)
    service = Users::Authenticate.call(
      username: user.name, password_digest: user.password_digest
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
