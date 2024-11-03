require 'sinatra'
require_relative '../controllers/survey'

survey_controller = SurveyController.new

get '/status' do
    content_type :json
    survey_controller.getStatuses
  end