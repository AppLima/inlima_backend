require_relative '../repository/base'
require_relative '../configs/models'

class ChangeRepository < RepositoryBase
  def initialize
    super(Change)
  end
end

$change_repository = ChangeRepository.new

module ChangeDAO
  def self.find_all
    $change_repository.find_all
  end

  def self.create(data)
    $change_repository.create(data)
  end

  def self.find_one(id)
    $change_repository.find_one(id)
  end

  def self.update(data)
    $change_repository.update(data[:id], data)
  end

  def self.remove(id)
    $change_repository.remove(id)
  end
end
