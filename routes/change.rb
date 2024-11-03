require 'sinatra'
require_relative '../controllers/change'

change_controller = ChangeController.new

post '/record_change' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  #token = request.env["HTTP_AUTHORIZATION"]
  #change_controller.record_change(token, data)
  change_controller.record_change(data)
end
