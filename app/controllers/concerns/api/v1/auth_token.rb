class Api::V1::AuthToken
  SECRET_KEY = Rails.application.secrets.secret_key_base

  def self.encode(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY).first
  rescue
    nil
  end
end
