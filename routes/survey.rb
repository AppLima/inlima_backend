require 'sinatra'
require_relative '../controllers/survey'

survey_controller = SurveyController.new

post '/create_survey' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  #token = request.env["HTTP_AUTHORIZATION"]
  #change_controller.record_change(token, data)
  survey_controller.createSurvey(data)
end