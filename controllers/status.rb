require 'json'
require_relative '../DAO/status'

class StatusController
    def getStatuses()
        begin
            statuses = StatusDAO.find_all()
            { success: true, message: "Datos recuperados", data: statuses }.to_json
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error al recuperar los datos" }.to_json
        end
    end
end
    