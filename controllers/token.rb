require 'json'
require 'securerandom'
require_relative '../DAO/token'
require_relative '../helpers/notifier'

class TokenController
    def create_token_code(email)
        begin
            code = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
            token = TokenDAO.create({
                email: email,
                code: code
            })
            Notifier.notify_verification_code(email, code)
            { success: true, message: "Token de verificación creado", data: subjects }.to_json
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error al crear la encuesta" }.to_json
        end
    end

    def verify_token_code(email, code)
        begin
            tokens = TokenDAO.find_by_email(email)
            if tokens && tokens.any?
                tokens.each do |token|
                    creation_time = Time.parse(token[:dateofcreation]) - (5 * 3600)
                    time_elapsed = Time.now - creation_time
                    if token[:code] == code && time_elapsed <= 600
                        TokenDAO.remove(token[:id])
                        return { success: true, message: "Token válido" }.to_json
                    else
                        TokenDAO.remove(token[:id])
                    end
                end
                { success: false, message: "Token expirado o no coincide" }.to_json
            else
                { success: false, message: "No hay tokens" }.to_json
            end
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error al verificar token" }.to_json
        end
    end
end
    