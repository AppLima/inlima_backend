require_relative '../repository/base'
require_relative '../configs/models'

class GenderRepository < RepositoryBase
  def initialize
    super(Gender)
  end
end

$gender_repository = GenderRepository.new

module GenderDAO
  def self.find_all
    $gender_repository.find_all
  end

  def self.create(data)
    $gender_repository.create(data)
  end

  def self.find_one(id)
    $gender_repository.find_one(id)
  end

  def self.update(data)
    $gender_repository.update(data[:id], data)
  end

  def self.remove(id)
    $gender_repository.remove(id)
  end
end
