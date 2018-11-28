require 'jwt'

class Auth
  ALGORITHM = 'HS256'.freeze

  def self.issue(payload)
    exp_time = Time.now.to_i + ENV['TOKEN_LIFETIME'].try(:to_i)
    exp_payload = { data: payload, exp: exp_time }
    JWT.encode(
      exp_payload,
      ENV['AUTH_SECRET'],
      ALGORITHM
    )
  end

  def self.decode(token)
    JWT.decode(
      token,
      ENV['AUTH_SECRET'],
      true,
      algorithm: ALGORITHM
    ).first
  end
end
