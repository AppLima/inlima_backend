require 'sinatra'
require_relative '../controllers/user'

user_controller = UserController.new

post '/iniciar_sesion' do
  data = JSON.parse(request.body.read)
  user_controller.iniciar_sesion(data['email'], data['password'], response)
end

post '/iniciar_sesion_google' do
  data = JSON.parse(request.body.read)
  user_controller.iniciar_sesion_google(data['email'], response)
end

delete '/cerrar_sesion' do
  user_controller.cerrar_sesion(response)
end

put '/actualizar_cuenta' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  token = request.env['HTTP_AUTHORIZATION']
  user_controller.actualizar_cuenta(token, data)
end

get '/obtener_rol' do
  token = request.env['HTTP_AUTHORIZATION']
  user_controller.obtener_rol(token)
end

post '/encontrar_usuario' do
  data = JSON.parse(request.body.read)
  user_controller.encontrar_usuario(data['id_ciudadano'])
end

post '/find_user_by_email' do
  data = JSON.parse(request.body.read)
  user_controller.find_user_by_email(data['email'])
end

post '/reset_password' do
  data = JSON.parse(request.body.read)
  user_controller.reset_password(data['email'], data['password'])
end
