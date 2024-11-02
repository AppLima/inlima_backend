require_relative '../repository/base'
require_relative '../configs/models'

class PhotoRepository < RepositoryBase
  def initialize
    super(Photo)
  end
end

$photo_repository = PhotoRepository.new

module PhotoDAO
  def self.find_all
    $photo_repository.find_all
  end

  def self.create(data)
    $photo_repository.create(data)
  end

  def self.find_one(id)
    $photo_repository.find_one(id)
  end

  def self.update(data)
    $photo_repository.update(data[:id], data)
  end

  def self.remove(id)
    $photo_repository.remove(id)
  end
end
