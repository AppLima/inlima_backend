require 'json'
require_relative '../DAO/user'
require_relative '../DAO/citizen'
require_relative '../helpers/notifier'

class CitizenController
  def register(data)
    begin
      unless valid_email?(data[:email])
        return { success: false, message: "Correo electronico no valido" }.to_json
      end

      unless valid_password?(data[:password])
        return { success: false, message: "La contrasena debe tener al menos 8 caracteres, una letra mayuscula, una letra minuscula, un numero y un caracter especial" }.to_json
      end

      unless valid_phone_number?(data[:phone_number])
        return { success: false, message: "Numero de telefono no compatible" }.to_json
      end

      unless valid_dni?(data[:dni])
        return { success: false, message: "DNI no compatible" }.to_json
      end

      user = UserDAO.find_one_by_email(data[:email])
      if user
        return { success: false, message: "El usuario con el siguiente correo ya ha sido registrado" }.to_json
      end

      existing_citizen = CitizenDAO.find_one_by_dni(data[:dni])
      if existing_citizen
        return { success: false, message: "El DNI ya esta registrado" }.to_json
      end

      usuario = UserDAO.create({
        email: data[:email],
        password: data[:password],
        first_name: data[:first_name],
        last_name: data[:last_name],
        photo: '',
        role_id: 2,
        gender_id: data[:gender_id]
      })

      if usuario != false
        begin
          aux = CitizenDAO.create({
            dni: data[:dni],
            phone_number: data[:phone_number],
            user_id: usuario[:id],
            district_id: data[:district]
          })

          if aux
            Notifier.notify_welcome(usuario[:email], usuario[:first_name])
            { success: true, message: "Usuario creado con exito" }.to_json
          else
            UserDAO.remove(usuario[:id])
            { success: false, message: "Error al crear usuario" }.to_json
          end
        rescue => e
          UserDAO.remove(usuario[:id])
          puts "Error al crear ciudadano o enviar notificación: #{e.message}"
          { success: false, message: "Error al crear ciudadano o enviar notificación" }.to_json
        end
      else
        { success: false, message: "Error al crear usuario" }.to_json
      end
    rescue => e
      puts "Error durante el registro de usuario: #{e.message}"
      { success: false, message: "Error durante el registro de usuario" }.to_json
    end
  end
  def buscar_ciudadano_por_usuario_id(user_id)
    begin
      ciudadano = CitizenDAO.find_one_by_user_id(user_id)
      if ciudadano
        usuario = UserDAO.find_one(ciudadano[:user_id])
        puts "Ciudadano encontrado: #{ciudadano.inspect}"
        puts "Usuario encontrado: #{usuario.inspect}"
        { success: true, usuario: usuario, ciudadano: ciudadano }.to_json
      else
        { success: false, message: 'Ciudadano no encontrado para este usuario' }.to_json
      end
    rescue => e
      puts "Error al buscar ciudadano y usuario: #{e.message}"
      { success: false, message: 'Error interno al buscar ciudadano y usuario' }.to_json
    end
  end

  def update(data)
    begin
      # Buscar usuario y ciudadano
      usuario = UserDAO.find_one(data[:user_id])
      return { success: false, message: "Usuario no encontrado" }.to_json if usuario.nil?
  
      ciudadano = CitizenDAO.find_one_by_user_id(data[:user_id])
      return { success: false, message: "Ciudadano no encontrado" }.to_json if ciudadano.nil?
  
      # Detectar los cambios en el usuario
      cambios_usuario = {}
      {
        email: data[:email],
        password: data[:password],
        first_name: data[:first_name],
        last_name: data[:last_name],
        gender_id: data[:gender_id]
      }.each do |key, value|
        cambios_usuario[key] = value if value && value != usuario[key]
      end
  
      # Detectar los cambios en el ciudadano
      cambios_ciudadano = {}
      {
        dni: data[:dni],
        phone_number: data[:phone_number],
        district_id: data[:district]
      }.each do |key, value|
        cambios_ciudadano[key] = value if value && value != ciudadano[key]
      end
  
      # Si no hay cambios, retornar un mensaje
      if cambios_usuario.empty? && cambios_ciudadano.empty?
        return { success: false, message: "No hay cambios para actualizar" }.to_json
      end
  
      # Validaciones solo para los campos que cambiaron
      if cambios_usuario[:email] && !valid_email?(cambios_usuario[:email])
        return { success: false, message: "Correo electrónico no válido" }.to_json
      end
  
      if cambios_usuario[:password] && !valid_password?(cambios_usuario[:password])
        return { success: false, message: "La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula, un número y un carácter especial" }.to_json
      end
  
      if cambios_ciudadano[:phone_number] && !valid_phone_number?(cambios_ciudadano[:phone_number])
        return { success: false, message: "Número de teléfono no compatible" }.to_json
      end
  
      if cambios_ciudadano[:dni] && !valid_dni?(cambios_ciudadano[:dni])
        return { success: false, message: "DNI no compatible" }.to_json
      end
  
      # Validar si el nuevo email ya está registrado por otro usuario
      if cambios_usuario[:email]
        usuario_existente = UserDAO.find_one_by_email(cambios_usuario[:email])
        if usuario_existente && usuario_existente[:id] != usuario[:id]
          return { success: false, message: "El correo electrónico ya está registrado por otro usuario" }.to_json
        end
      end
  
      # Validar si el nuevo DNI ya está registrado por otro ciudadano
      if cambios_ciudadano[:dni]
        ciudadano_existente = CitizenDAO.find_one_by_dni(cambios_ciudadano[:dni])
        if ciudadano_existente && ciudadano_existente[:id] != ciudadano[:id]
          return { success: false, message: "El DNI ya está registrado por otro ciudadano" }.to_json
        end
      end
  
      # Actualizar usuario solo con los campos que cambiaron
      usuario_actualizado = UserDAO.update(usuario[:id], cambios_usuario) unless cambios_usuario.empty?
  
      # Actualizar ciudadano solo con los campos que cambiaron
      ciudadano_actualizado = CitizenDAO.update(ciudadano[:id], cambios_ciudadano) unless cambios_ciudadano.empty?
  
      # Verificar actualizaciones exitosas
      if usuario_actualizado || ciudadano_actualizado
        { success: true, message: "Perfil actualizado con éxito" }.to_json
      else
        { success: false, message: "Error al actualizar el perfil" }.to_json
      end
    rescue => e
      puts "Error durante la actualización del perfil: #{e.message}"
      { success: false, message: "Error durante la actualización del perfil: #{e.message}" }.to_json
    end
  end
  
  
  
  private

  def valid_email?(email)
    email =~ /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/
  end

  def valid_password?(password)
    password =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:;.,<>?\[\]\\|~`-]).{8,}$/
  end

  def valid_phone_number?(phone_number)
    phone_number =~ /^9\d{8}$/
  end

  def valid_dni?(dni)
    dni =~ /^\d{8}$/
  end

end
