require 'json'
require_relative '../DAO/survey'

class SurveyController
    def createSurvey(data)
        begin
            survey = SurveyDAO.create({
                title: data[:title],
                description: data[:description],
                photo: data[:photo],
                total_results: 0,
                postives: 0,
                negatives: 0,
                start_date: data[:start_date],
                end_date: data[:end_date],
                status: 1,
                district_id: data[:district_id]
            })
            { success: true, message: "Encuesta creada con exito", data: survey }.to_json
        rescue => e
            puts "Error: #{e.message}"
            { success: false, message: "Error al crear la encuesta" }.to_json
        end
    end
end