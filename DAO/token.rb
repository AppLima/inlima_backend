require_relative '../repository/base'
require_relative '../configs/models'

class TokenRepository < RepositoryBase
  def initialize
    super(Token)
  end
end

$token_repository = TokenRepository.new

module TokenDAO
  def self.find_all
    $token_repository.find_all
  end

  def self.create(data)
    $token_repository.create(data)
  end

  def self.find_one(id)
    $token_repository.find_one(id)
  end

  def self.find_by_email(email)
    $user_repository.find_all(email: email).first
  end

  def self.update(data)
    $token_repository.update(data[:id], data)
  end

  def self.remove(id)
    $token_repository.remove(id)
  end
end
