require 'json'
require_relative '../DAO/user'
require_relative '../DAO/citizen'
require_relative '../helpers/notifier'

class CitizenController
  def register(data)
    begin
      # Validación del email
      unless valid_email?(data[:email])
        return { success: false, message: "Correo electrónico no válido" }.to_json
      end

      # Validación de la contraseña (ejemplo básico)
      unless valid_password?(data[:password])
        return { success: false, message: "La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula y un número" }.to_json
      end

      # Comprobar si el usuario ya existe por correo
      user = UserDAO.find_one_by_email(data[:email])
      if user
        return { success: false, message: "El usuario con el siguiente correo ya ha sido registrado" }.to_json
      end

      # Comprobar si el DNI ya está registrado
      existing_citizen = CitizenDAO.find_one_by_dni(data[:dni])
      if existing_citizen
        return { success: false, message: "El DNI ya está registrado" }.to_json
      end

        # Crear el usuario
        usuario = UserDAO.create({
          email: data[:email],
          password: data[:password],
          first_name: data[:first_name],
          last_name: data[:last_name],
          photo: '',
          role_id: 2,
          gender_id: data[:gender]
        })

        if usuario != false
          begin
            # Crear el ciudadano con el ID del usuario recién creado
            aux = CitizenDAO.create({
              dni: data[:dni],
              phone_number: data[:phone_number],
              user_id: usuario[:id],
              district_id: data[:district]
            })

          if aux
            # Enviar notificación de bienvenida
            Notifier.notify_welcome(usuario[:email], usuario[:first_name])
            { success: true, message: "Usuario creado con exito" }.to_json
          else
            # Eliminar el usuario si hubo un error al crear el ciudadano
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

  private

  # Validación básica del email usando una expresión regular
  def valid_email?(email)
    email =~ /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/
  end

  # Validación de la contraseña (mínimo 8 caracteres, una mayúscula, una minúscula y un número)
  def valid_password?(password)
    password =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}:;.,<>?\[\]\\|~`-]).{8,}$/
  end
end
