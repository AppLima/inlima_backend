require 'json'
require_relative '../DAO/user'
require_relative '../DAO/citizen'
require_relative '../DAO/complaint'

class citizenController
    def register (data)
        ciudadano = CitizenDAO.find_one_by_email(data[:email]),
        if ciudadano
            { success: false, message: "El usuario ya ha sido registrado" }.to_json
        else
            usuario = UserDAO.create({
                email: data[:email],
                password: data[:password],
                first_name: data[:first_name],
                last_name: data[:last_name],
                photo: '',
                role_id: 2,
                gender_id: data[:gender]
            })
            if usuario
                aux = CitizenDAO.create({
                    dni: data[:dni],
                    phone_numer: data[:phone_numer],
                    user_id: usuario[:id],
                    district_id: data[:district]
                })
                if aux
                    { success: true, message: "Usuario creado con exito"}.to_json
                else
                    ##Se tendria que eliminar el usuario creado
                    { success: false, message: "Error al crear usuario" }.to_json
                end     
            else
                { success: false, message: "Error al crear usuario" }.to_json
            end
        end
    end
end