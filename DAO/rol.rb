require_relative '../repository/base'
require_relative '../configs/models'

class RolRepository < RepositoryBase
  def initialize
    super(Rol)
  end
end

$rol_repository = RolRepository.new

module RolDAO
  def self.find_all
    $rol_repository.find_all
  end

  def self.create(data)
    $rol_repository.create(data)
  end

  def self.find_one(id)
    $rol_repository.find_one(id)
  end

  def self.update(data)
    $rol_repository.update(data[:id], data)
  end

  def self.remove(id)
    $rol_repository.remove(id)
  end
end
