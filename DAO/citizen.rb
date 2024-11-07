require_relative '../repository/base'
require_relative '../configs/models'

class CitizenRepository < RepositoryBase
  def initialize
    super(Citizen)
  end
end

$citizen_repository = CitizenRepository.new

module CitizenDAO
  def self.find_all
    $citizen_repository.find_all
  end

  def self.find_all_by_id(id)
    $citizen_repository.find_all(id: id)
  end

  def self.create(data)
    $citizen_repository.create(data)
  end

  def self.find_one(id)
    $citizen_repository.find_one(id)
  end

  def self.find_one_by_user_id(usuario_id)
    Citizen.where(user_id: usuario_id).first
  end

  def self.update(data)
    $citizen_repository.update(data[:id], data)
  end

  def self.find_one_by_dni(dni)
    Citizen.where(dni: dni).first
  end

  def self.remove(id)
    $citizen_repository.remove(id)
  end
end

