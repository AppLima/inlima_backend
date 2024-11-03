# routes/complaint.rb
require 'sinatra'
require_relative '../controllers/complaint'

complaint_controller = ComplaintController.new

# Ruta para agregar una queja
post '/complaint' do
  content_type :json
  token = request.env['HTTP_AUTHORIZATION']
  data = JSON.parse(request.body.read, symbolize_names: true)
  #complaint_controller.agregar_queja(data)
  complaint_controller.agregar_queja(token, data)
end

# Ruta para obtener la ubicación de una queja
get '/complaint/:id/location' do
  content_type :json
  complaint_controller.encontrar_ubicacion(params[:id].to_i)
end

# Ruta para obtener el distrito de una queja
get '/complaint/:id/district' do
  content_type :json
  complaint_controller.encontrar_distrito(params[:id].to_i)
end

# Ruta para obtener quejas filtradas
post '/complaints/filter' do
  content_type :json
  #token = request.env['HTTP_AUTHORIZATION']
  filtros = JSON.parse(request.body.read, symbolize_names: true)
  complaint_controller.obtener_quejas_filtradas(token, filtros)
end

# Ruta para obtener los detalles de una queja específica
get '/complaint/:id/details' do
  content_type :json
  complaint_controller.obtener_queja_con_detalles(params[:id].to_i)
end

# Ruta para actualizar el estado de una queja
put '/complaint/:id/status' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  complaint_controller.actualizar_estado(params[:id].to_i, data[:estado_id])
end

# Ruta para obtener las quejas de un usuario
get '/user/complaints' do
  content_type :json
  #token = request.env['HTTP_AUTHORIZATION']
  complaint_controller.obtener_quejas_usuario(token)
end

# Ruta para actualizar la puntuación de una queja
put '/complaint/:id/rating' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  complaint_controller.actualizar_puntuacion(params[:id].to_i, data[:calificacion])
end

# Ruta para actualizar la prioridad de una queja
put '/complaint/:id/priority' do
  content_type :json
  #token = request.env['HTTP_AUTHORIZATION']
  data = JSON.parse(request.body.read, symbolize_names: true)
  complaint_controller.actualizar_prioridad(token, params[:id].to_i, data[:prioridad])
end
