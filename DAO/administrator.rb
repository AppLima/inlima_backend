require_relative '../repository/base'
require_relative '../configs/models'

class AdministratorRepository < RepositoryBase
  def initialize
    super(Administrator)
  end
end

$administrator_repository = AdministratorRepository.new

module AdministratorDAO
  def self.find_all()
    $administrator_repository.find_all
  end

  def self.create(data)
    $administrator_repository.create(data)
  end

  def self.find_one(id)
    $administrator_repository.find_one(id)
  end

  def self.find_one_by_user_id(usuario_id)
    Administrator.where(user_id: usuario_id).first
  end

  def self.update(data)
    $administrator_repository.update(data[:id], data)
  end

  def self.remove(id)
    $administrator_repository.remove(id)
  end
end
