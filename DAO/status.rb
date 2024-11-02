require_relative '../repository/base'
require_relative '../configs/models'

class StatusRepository < RepositoryBase
  def initialize
    super(Status)
  end
end

$status_repository = StatusRepository.new

module StatusDAO
  def self.find_all
    $status_repository.find_all
  end

  def self.create(data)
    $status_repository.create(data)
  end

  def self.find_one(id)
    $status_repository.find_one(id)
  end

  def self.update(data)
    $status_repository.update(data[:id], data)
  end

  def self.remove(id)
    $status_repository.remove(id)
  end
end
