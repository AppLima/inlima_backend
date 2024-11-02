require_relative '../repository/base'
require_relative '../configs/models'

class DistrictRepository < RepositoryBase
  def initialize
    super(District)
  end
end

$district_repository = DistrictRepository.new

module DistrictDAO
  def self.find_all
    $district_repository.find_all
  end

  def self.create(data)
    $district_repository.create(data)
  end

  def self.find_one(id)
    $district_repository.find_one(id)
  end

  def self.update(data)
    $district_repository.update(data[:id], data)
  end

  def self.remove(id)
    $district_repository.remove(id)
  end
end
