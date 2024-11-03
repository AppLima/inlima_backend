require 'sinatra'
require_relative '../controllers/status'

status_controller = StatusController.new

post '/status' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  #token = request.env["HTTP_AUTHORIZATION"]
  #change_controller.record_change(token, data)
  change_controller.record_change(data)
end
