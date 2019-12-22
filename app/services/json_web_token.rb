class JsonWebToken
  def self.encode(payload, exp = Constants::TOKEN_EXP_DATE.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def self.decode(token)
    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
