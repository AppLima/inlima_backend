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

get '/complaint/:id/details' do
  content_type :json
  complaint_controller.obtener_queja_con_detalles(params[:id].to_i)
end

get '/user/complaints' do
  content_type :json
  token = request.env['HTTP_AUTHORIZATION']
  complaint_controller.obtener_quejas_usuario(token)
end