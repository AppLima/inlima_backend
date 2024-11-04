require 'sinatra'
require_relative '../controllers/citizen'

citizen_controller = CitizenController.new

post '/register' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  citizen_controller.register(data)
end
