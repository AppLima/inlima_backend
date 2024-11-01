# repositories/repository_base.rb

class RepositoryBase
    def initialize(modelo)
      @modelo = modelo
    end
  
    # Encontrar todos los registros, con filtros opcionales
    def find_all(props = {})
      @modelo.where(props).all
    rescue Sequel::Error => e
      puts "Error al obtener todos los registros: #{e.message}"
      nil
    end
   
    # Crear un nuevo registro
    def create(object)
      @modelo.create(object)
    rescue Sequel::Error => e
      puts "Error al crear el registro: #{e.message}"
      nil
    end
  
    # Encontrar un registro por ID
    def find_one(id)
      @modelo.where(id: id).first
    rescue Sequel::Error => e
      puts "Error al encontrar el registro: #{e.message}"
      nil
    end
  
    # Actualizar un registro existente
    def update(id, attributes)
      record = @modelo.where(id: id).first
      return nil unless record
  
      record.update(attributes)
      record
    rescue Sequel::Error => e
      puts "Error al actualizar el registro: #{e.message}"
      nil
    end
  
    # Eliminar un registro por ID
    def remove(id)
      record = @modelo.where(id: id).first
      record.destroy if record
      !record.nil?
    rescue Sequel::Error => e
      puts "Error al eliminar el registro: #{e.message}"
      nil
    end
  end
  