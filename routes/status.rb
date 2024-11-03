require 'sinatra'
require_relative '../controllers/status'

status_controller = StatusController.new

get '/status' do
    content_type :json
    survey_controller.getStatuses
  end