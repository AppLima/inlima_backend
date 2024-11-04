require 'sinatra'
require_relative '../controllers/survey'

survey_controller = SurveyController.new

post '/create_survey' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  survey_controller.createSurvey(data)
end