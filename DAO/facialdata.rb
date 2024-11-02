require_relative '../repository/base'
require_relative '../configs/models'

class FacialDataRepository < RepositoryBase
  def initialize
    super(FacialData)
  end
end

$facialdata_repository = FacialDataRepository.new

module FacialDataDAO
  def self.find_all
    $facialdata_repository.find_all
  end

  def self.create(data)
    $facialdata_repository.create(data)
  end

  def self.find_one(id)
    $facialdata_repository.find_one(id)
  end

  def self.update(data)
    $facialdata_repository.update(data[:id], data)
  end

  def self.remove(id)
    $facialdata_repository.remove(id)
  end
end
