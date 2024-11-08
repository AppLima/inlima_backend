require 'sinatra'
require_relative '../controllers/response'

response_controller = ResponseController.new

post '/record_response' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  token = request.env["HTTP_AUTHORIZATION"]
  response_controller.record_response(token, data)
end
