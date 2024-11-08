# controller/user.rb
require 'jwt'
require 'json'
require_relative '../helpers/auth_helper'
require_relative '../DAO/user'
require_relative '../DAO/citizen'
require 'dotenv/load'

class UserController
  include AuthHelper
  SECRET_KEY = ENV['SECRET_KEY']

  def iniciar_sesion(email, password, response)
    usuario = UserDAO.find_one_by_email(email)
    if usuario && usuario[:password] == password
      token = generar_token(usuario)
      { success: true, message: 'Inicio de sesión exitoso', data: usuario, token: token }.to_json
    else
      { success: false, message: 'Credenciales incorrectas' }.to_json
    end
  end

  def actualizar_cuenta(token, data)
    usuario = verificar_token(token)
    if usuario
      if data[:password]
        unless valid_password?(data[:password])
          return { success: false, message: 'La contraseña no cumple con los requisitos de seguridad' }.to_json
        end
        updated_user = UserDAO.update_perfil(usuario[:id], data)
      end
      if updated_user
        { success: true, message: 'Datos actualizados con éxito' }.to_json
      else
        { success: false, message: 'Error al actualizar los datos' }.to_json
      end
    else
      { success: false, message: 'Usuario no encontrado' }.to_json
    end
  end
  
  def valid_password?(password)
    # Revisar la contraseña con mensajes de depuración
    min_length = password.length >= 8
    has_uppercase = password =~ /[A-Z]/
    has_lowercase = password =~ /[a-z]/
    has_digit = password =~ /\d/
    has_special_char = password =~ /[!@#$%^&*()_+{}\[\]:;.,<>?\|\\~\-]/
  
    puts "Longitud mínima: #{min_length}, Mayúscula: #{has_uppercase}, Minúscula: #{has_lowercase}, Dígito: #{has_digit}, Carácter especial: #{has_special_char}"  # Depuración
  
    # Asegurarse de que todas las condiciones se cumplan
    min_length && has_uppercase && has_lowercase && has_digit && has_special_char
  end

  def encontrar_usuario(id_ciudadano)
    ciudadano = CitizenDAO.find_one(id_ciudadano)
    if ciudadano
      usuario = UserDAO.find_one(ciudadano[:usuario_id])
      { success: true, usuario: usuario }.to_json
    else
      { success: false, message: 'Usuario no encontrado' }.to_json
    end
  end

  def find_user_token(token)
    usuario = verificar_token(token)
    if usuario
      encontrado = UserDAO.find_one(usuario[:id])
      { success: true, usuario: encontrado }.to_json
    else
      { success: false, message: 'Token no valido' }.to_json
    end
  end

  def find_user_by_email(email)
    usuario = UserDAO.find_one_by_email(email)
    if usuario
      { success: true }.to_json
    else
      { success: false, message: "No se encontró al usuario mediante el email: #{email}" }.to_json
    end
  end

  def reset_password(email, new_password)
    # Validación de la nueva contraseña
    if !valid_password?(new_password)
      return { success: false, message: 'La contraseña no cumple con los requisitos de seguridad' }.to_json
    end

    usuario = UserDAO.find_one_by_email(email)
    if usuario
      UserDAO.reset_password(usuario[:id], new_password)
      { success: true, message: 'Contraseña actualizada con éxito' }.to_json
    else
      { success: false, message: 'Usuario no encontrado' }.to_json
    end
  end

  private

  def generar_token(usuario)
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

  def terms_conditions(option)
    usuario = verificar_token(token)
    if usuario
      if option
        aux = UserDAO.update_perfil(usuario[:id], terms_conditions: 1)
        if aux
          { success: true, message: 'Terminos actualizados' }.to_json
        else
          { success: false, message: 'Error al actualizar' }.to_json
        end
      end
    else
      { success: false, message: 'Usuario no encontrado' }.to_json
    end
  end
end
