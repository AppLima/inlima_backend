# controller/user.rb
require 'jwt'
require 'json'
require_relative '../DAO/user'
require_relative '../DAO/citizen'

class UserController
  SECRET_KEY = 'secret'

  def iniciar_sesion(email, password, response)
    usuario = UserDAO.find_one_by_email(email)
    if usuario && usuario[:password] == password
      token = generar_token(usuario)
      { success: true, message: 'Inicio de sesión exitoso', data: usuario, token: token }.to_json
    else
      { success: false, message: 'Credenciales incorrectas' }.to_json
    end
  end

  #def cerrar_sesion(response)
   # eliminar_cookie(response)
    #{ message: 'Sesión cerrada correctamente' }.to_json
  #end

  # Actualizar cuenta
  def actualizar_cuenta(token, data)
    usuario = verificar_token(token)
    if usuario
      updated_user = UserDAO.update_perfil(usuario[:id], data)
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
      { success: true, rol: usuario[:role_id] }.to_json
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
      { success: false, message: 'Usuario no encontrado' }.to_json
    end
  end

  private

  # Generar token JWT
  def generar_token(usuario)
    puts usuario
    payload = {
      exp: Time.now.to_i + 60 * 60 * 24 * 30,
      id: usuario[:id],
      email: usuario[:email],
      first_name: usuario[:first_name],
      last_name: usuario[:last_name],
      photo: usuario[:photo],
      role: usuario[:role_id]
    }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end
end
