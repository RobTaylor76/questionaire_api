class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, jwt_secret_key)
    end

    def decode(token)
      body = JWT.decode(token, jwt_secret_key)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end

    def jwt_secret_key
      Rails.application.credentials.jwt_secret_key
    end
  end
end