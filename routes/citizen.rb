require 'sinatra'
require_relative '../controllers/citizen'

citizen_controller = CitizenController.new

post '/register' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  citizen_controller.register(data)
end

# Ruta para buscar ciudadano y usuario por el ID del usuario
get '/citizen/user/:id' do
  content_type :json
  user_id = params[:id].to_i
  citizen_controller.buscar_ciudadano_por_usuario_id(user_id)
end

# Ruta para actualizar el perfil de un ciudadano
put '/citizen/update' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  citizen_controller.update(data)
end