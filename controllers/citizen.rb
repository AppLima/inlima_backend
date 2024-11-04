require 'json'
require_relative '../DAO/user'
require_relative '../DAO/citizen'
require_relative '../DAO/complaint'
require_relative '../helpers/notifier'

class CitizenController
  def register(data)
    begin
      user = UserDAO.find_one_by_email(data[:email])
      if user
        return { success: false, message: "El usuario ya ha sido registrado" }.to_json
      end

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
end
