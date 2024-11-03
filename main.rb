require 'sinatra'
require 'sequel' # Agregar para el manejo de cookies
require 'jwt' # Agregar para el manejo de JWT

# Configuración
set :public_folder, File.dirname(__FILE__) + '/public'
set :views, File.dirname(__FILE__) + '/views'
set :protection, except: :frame_options
set :bind, 'localhost'
set :port, 4567

# Conexión a la base de datos
require_relative 'configs/database'
require_relative 'configs/models'

# Endpoints
Dir[File.join(__dir__, 'routes', '*.rb')].each { |file| require_relative file }

# Configuración CORS
before do
  headers 'Access-Control-Allow-Origin' => '*', # Permitir acceso desde cualquier origen
          'Access-Control-Allow-Methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'], # Permitir los métodos HTTP especificados
          'Access-Control-Allow-Headers' => 'Content-Type' # Permitir el encabezado Content-Type
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,POST,DELETE,OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  200
end

# Ruta de prueba o inicio
get '/' do
  erb :home
end

# Middleware o Helpers para manejo de autenticación

# Verificar si el usuario está autenticado a través de cookies (helper)

helpers do
  def authenticate_request
    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last #|| request.cookies['myToken']
    halt 401, { success: false, message: 'Token no encontrado o inválido' }.to_json unless token
    
    begin
      JWT.decode(token, 'secret', true, algorithm: 'HS256').first
    rescue JWT::DecodeError
      halt 401, { success: false, message: 'Token no válido' }.to_json
    end
  end
end
