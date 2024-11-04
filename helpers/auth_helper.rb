require 'jwt'
require 'dotenv/load'

module AuthHelper
  SECRET_KEY = ENV['SECRET_KEY']

  def verificar_token(token)
    begin
      payload = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
      payload.transform_keys(&:to_sym)
    rescue JWT::DecodeError => e
      { error: true, status: 401, message: 'Token no válido' }
    end
  end
end
