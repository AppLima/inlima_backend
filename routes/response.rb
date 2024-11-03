require 'sinatra'
require_relative '../controllers/response'

response_controller = ResponseController.new

post '/record_response' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  #token = request.env["HTTP_AUTHORIZATION"]
  #change_controller.record_change(token, data)
  response_controller.record_response(data)
end
