require 'jwt'

module AuthHelper
  SECRET_KEY = 'secret'

  def verificar_token(token)
    begin
      payload = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
      payload.transform_keys(&:to_sym)
    rescue JWT::DecodeError
      { error: true, status: 401, message: 'Token no válido' }
    end
  end
  
  def respuesta_error(status, mensaje)
    { success: false, status: status, message: mensaje }
  end
end
