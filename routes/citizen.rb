require 'sinatra'
require_relative '../controllers/citizen'

citizen_controller = CitizenController.new

post '/register' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  #token = request.env["HTTP_AUTHORIZATION"]
  #change_controller.record_change(token, data)
  citizen_controller.register(data)
end
