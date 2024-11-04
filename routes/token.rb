# routes/token.rb
require 'sinatra'
require_relative '../controllers/token'

token_controller = TokenController.new

# Ruta para crear un token de verificación
post '/token/create' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  token_controller.create_token_code(data[:email])
end

# Ruta para verificar un token de verificación
post '/token/verify' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  token_controller.verify_token_code(data[:email], data[:code])
end
