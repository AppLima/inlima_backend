require_relative '../repository/base'
require_relative '../configs/models'

class SubjectRepository < RepositoryBase
  def initialize
    super(Subject)
  end
end

$subject_repository = SubjectRepository.new

module SubjectDAO
  def self.find_all
    $subject_repository.find_all
  end

  def self.create(data)
    $subject_repository.create(data)
  end

  def self.find_one(id)
    $subject_repository.find_one(id)
  end

  def self.update(data)
    $subject_repository.update(data[:id], data)
  end

  def self.remove(id)
    $subject_repository.remove(id)
  end
end
