require 'json'
require_relative '../DAO/district'

class DistrictController
    def getDistricts()
        begin
            districts = DistrictDAO.find_all()
            { success: true, message: "Datos de municipalidades recuperados", data: districts }.to_json
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error al crear la queja" }.to_json
        end
    end
end
    