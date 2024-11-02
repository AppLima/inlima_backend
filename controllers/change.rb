# controller/historial.rb
require_relative '../repository/base'
require_relative '../configs/models'
require 'json'

class ChangeController
  def initialize
    # Crea una instancia de RepositoryBase para el modelo Historial
    @repository = RepositoryBase.new(Change)
  end

  # Obtener todos los registros
  def find_all(req, res)
    result = @repository.find_all
    res.status = 200
    res['Content-Type'] = 'application/json'
    res.write(result.to_json)
  end

  # Crear un nuevo registro
  def create(req, res)
    data = JSON.parse(req.body.read)
    result = @repository.create(data)
    res.status = 200
    res['Content-Type'] = 'application/json'
    res.write(result.to_json)
  end

  # Obtener un registro por ID
  def find_one(req, res)
    id = req.params['id'].to_i
    result = @repository.find_one(id)

    res['Content-Type'] = 'application/json'
    if result
      res.status = 200
      res.write(result.to_json)
    else
      res.status = 500
      res.write({ message: 'No encontrado.' }.to_json)
    end
  end

  # Actualizar un registro
  def update(req, res)
    data = JSON.parse(req.body.read)
    result = @repository.update(data[:id], data)

    res['Content-Type'] = 'application/json'
    if result
      res.status = 200
      res.write(result.to_json)
    else
      res.status = 500
      res.write({ message: 'No encontrado.' }.to_json)
    end
  end

  # Eliminar un registro
  def remove(req, res)
    id = req.params['id'].to_i
    result = @repository.remove(id)

    res['Content-Type'] = 'application/json'
    if result
      res.status = 200
      res.write({ message: 'Registro eliminado' }.to_json)
    else
      res.status = 500
      res.write({ message: 'No encontrado.' }.to_json)
    end
  end
end
