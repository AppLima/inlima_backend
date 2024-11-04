require 'json'
require_relative '../DAO/response'
require_relative '../helpers/auth_helper'

class ResponseController
    include AuthHelper
    def record_response(token, data)
        begin
            usuario = verificar_token(token)
            ciudadano = CitizenDAO.find_one_by_user_id(usuario[:id])
            
            response = ResponseDAO.create({
                option: data[:option],
                citizen_id: ciudadano[:id],
                survey_id: data[:survey_id]
            })

            { success: true, message: "Respuesta registrada satisfactoriamente", data: response }.to_json
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error al registrar respuesta" }.to_json
        end
    end
end
    