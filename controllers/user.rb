# controller/user.rb
require 'jwt'
require 'json'
require_relative '../DAO/user'
require_relative '../DAO/citizen'

class UserController
  SECRET_KEY = 'secret'

  # Método para iniciar sesión
  def iniciar_sesion(email, password, response)
    usuario = UserDAO.find_one_by_email(email)
    if usuario && usuario[:password] == password
      token = generar_token(usuario)
      establecer_cookie(response, token)
      { success: true, message: 'Inicio de sesión exitoso' }.to_json
    else
      respuesta_error(401, 'Credenciales incorrectas')
    end
  end

  # Método para iniciar sesión con Google
  def iniciar_sesion_google(email, response)
    usuario = UserDAO.find_one_by_email(email)
    if usuario
      token = generar_token(usuario)
      establecer_cookie(response, token)
      { success: true, message: 'Inicio de sesión exitoso' }.to_json
    else
      respuesta_error(401, 'Credenciales incorrectas')
    end
  end

  # Cerrar sesión
  def cerrar_sesion(response)
    eliminar_cookie(response)
    { message: 'Sesión cerrada correctamente' }.to_json
  end

  # Actualizar cuenta
  def actualizar_cuenta(token, password, photo)
    usuario = verificar_token(token)
    if usuario
      updated_user = UserDAO.update_perfil(usuario[:id], password, photo)
      if updated_user
        { success: true, message: 'Datos actualizados con éxito' }.to_json
      else
        respuesta_error(500, 'Error al actualizar los datos')
      end
    else
      respuesta_error(404, 'Usuario no encontrado')
    end
  end

  # Obtener rol de usuario
  def obtener_rol(token)
    usuario = verificar_token(token)
    if usuario
      { success: true, rol: usuario[:rol_id] }.to_json
    else
      respuesta_error(401, 'Token no válido')
    end
  end

  # Encontrar usuario por id_ciudadano
  def encontrar_usuario(id_ciudadano)
    ciudadano = CitizenDAO.find_one(id_ciudadano)
    if ciudadano
      usuario = UserDAO.find_one(ciudadano[:usuario_id])
      { success: true, usuario: usuario }.to_json
    else
      respuesta_error(404, 'Usuario no encontrado')
    end
  end

  # Encontrar usuario por token
  def find_user_token(token)
    usuario = verificar_token(token)
    if usuario
      encontrado = UserDAO.find_one(usuario[:id])
      { success: true, usuario: encontrado }.to_json
    else
      respuesta_error(401, 'Token no válido')
    end
  end

  # Encontrar usuario por email
  def find_user_by_email(email)
    usuario = UserDAO.find_one_by_email(email)
    if usuario
      { success: true }.to_json
    else
      { success: false, message: "No se encontró al usuario mediante el email: #{email}" }.to_json
    end
  end

  # Resetear contraseña
  def reset_password(email, new_password)
    usuario = UserDAO.find_one_by_email(email)
    if usuario
      UserDAO.reset_password(usuario[:id], new_password)
      { success: true, message: 'Contraseña actualizada con éxito' }.to_json
    else
      respuesta_error(404, 'Usuario no encontrado')
    end
  end

  private

  # Generar token JWT
  def generar_token(usuario)
    payload = {
      exp: Time.now.to_i + 60 * 60 * 24 * 30,
      rol: usuario[:rol_id],
      id: usuario[:id],
      email: usuario[:email],
      nombre: usuario[:nombre]
    }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  # Verificar y decodificar el token JWT
  def verificar_token(token)
    payload = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
    payload.transform_keys(&:to_sym)
  rescue JWT::DecodeError
    nil
  end

  # Establecer cookie con el token
  def establecer_cookie(response, token)
    response.set_cookie('myToken', {
      value: token,
      path: '/',
      httponly: true,
      secure: false,
      same_site: 'Lax'
    })
  end

  # Eliminar la cookie
  def eliminar_cookie(response)
    response.set_cookie('myToken', {
      value: nil,
      path: '/',
      max_age: '0',
      httponly: true,
      secure: false,
      same_site: 'Lax'
    })
  end

  # Manejo de respuesta de error
  def respuesta_error(status, mensaje)
    { success: false, message: mensaje }.to_json
  end
end
