require 'json'
require_relative '../DAO/subject'

class SubjectController
    def getSubjects()
        begin
            subjects = SubjectDAO.find_all()
            { success: true, message: "Datos recuperados", data: subjects }.to_json
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error al recuperar datos" }.to_json
        end
    end
end
    