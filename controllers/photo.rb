require 'json'
require_relative '../DAO/photo'
require_relative '../helpers/auth_helper'

class DistrictController
    def getPhoto(token, data)
        begin
            districts = DistrictDAO.find_all()
            { success: true, message: "Datos de municipalidades recuperados", data: districts }.to_json
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error recuperar datos" }.to_json
        end
    end
end
    