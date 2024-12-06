# routes/complaint.rb
require 'sinatra'
require_relative '../controllers/complaint'

complaint_controller = ComplaintController.new

post '/complaint' do
  content_type :json
  token = request.env['HTTP_AUTHORIZATION']
  data = JSON.parse(request.body.read, symbolize_names: true)
  complaint_controller.add_complaint(token, data)
end

get '/complaint/:id/location' do
  content_type :json
  complaint_controller.encontrar_ubicacion(params[:id].to_i)
end

get '/complaint/:id/district' do
  content_type :json
  complaint_controller.encontrar_distrito(params[:id].to_i)
end

post '/complaints/filtered' do
  begin
    token = request.env['HTTP_AUTHORIZATION']
    if token.nil? || token.empty?
      return { success: false, message: 'Token no proporcionado' }.to_json
    end
    filtros = JSON.parse(request.body.read, symbolize_names: true)
    complaint_controller.obtener_quejas_filtradas(token, filtros)
  rescue JSON::ParserError
    { success: false, message: 'Error en el formato de la solicitud' }.to_json
  end
end

post '/complaints/getfullcomplaint' do
  begin
    token = request.env['HTTP_AUTHORIZATION']
    if token.nil? || token.empty?
      return { success: false, message: 'Token no proporcionado' }.to_json
    end
    data = JSON.parse(request.body.read, symbolize_names: true)
    complaint_controller.getfullcomplaint(token, data)
  rescue JSON::ParserError
    { success: false, message: 'Error en el formato de la solicitud' }.to_json
  end
end

get '/complaint/:id/details' do
  content_type :json
  complaint_controller.obtener_queja_con_detalles(params[:id].to_i)
end

get '/user/complaints' do
  content_type :json
  token = request.env['HTTP_AUTHORIZATION']
  complaint_controller.obtener_quejas_usuario(token)
end

put '/complaint/:id/status' do
  content_type :json
  begin
    token = request.env['HTTP_AUTHORIZATION']
    if token.nil? || token.empty?
      return { success: false, message: 'Token no proporcionado' }.to_json
    end

    # Parsear el cuerpo de la solicitud para obtener el nuevo estado
    data = JSON.parse(request.body.read, symbolize_names: true)
    data[:complaint_id] = params[:id].to_i # Agregar el ID de la queja desde la URL

    # Llamar al controlador para actualizar el estado
    complaint_controller.actualizar_estado_queja(token, data)
  rescue JSON::ParserError
    { success: false, message: 'Error en el formato de la solicitud' }.to_json
  end
end
