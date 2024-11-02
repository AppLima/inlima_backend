require_relative '../repository/base'
require_relative '../configs/models'

class ResponseRepository < RepositoryBase
  def initialize
    super(Response)
  end
end

$response_repository = ResponseRepository.new

module ResponseDAO
  def self.find_all
    $response_repository.find_all
  end

  def self.create(data)
    $response_repository.create(data)
  end

  def self.find_one(id)
    $response_repository.find_one(id)
  end

  def self.update(data)
    $response_repository.update(data[:id], data)
  end

  def self.remove(id)
    $response_repository.remove(id)
  end
end
