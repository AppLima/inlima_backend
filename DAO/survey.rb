require_relative '../repository/base'
require_relative '../configs/models'

class SurveyRepository < RepositoryBase
  def initialize
    super(Survey)
  end
end

$survey_repository = SurveyRepository.new

module SurveyDAO
  def self.find_all
    $survey_repository.find_all
  end

  def self.create(data)
    $survey_repository.create(data)
  end

  def self.find_one(id)
    $survey_repository.find_one(id)
  end

  def self.update(data)
    $survey_repository.update(data[:id], data)
  end

  def self.remove(id)
    $survey_repository.remove(id)
  end
end
