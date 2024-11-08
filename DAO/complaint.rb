require_relative '../repository/base'
require_relative '../configs/models'

class ComplaintRepository < RepositoryBase
  def initialize
    super(Complaint)
  end
end

$complaint_repository = ComplaintRepository.new

module ComplaintDAO
  def self.find_all
    $complaint_repository.find_all
  end

  def self.find_all_by_ciudadano_id(ciudadano_id)
    Complaint.where(ciudadano_id: ciudadano_id).eager(:status, citizen: [:user], district: [:name]).all
  rescue Sequel::Error => e
    puts "Error al buscar quejas por ciudadano_id: #{e.message}"
    nil
  end

  def self.create(data)
    $complaint_repository.create(data)
  end

  def self.find_one(id)
    $complaint_repository.find_one(id)
  end

  def self.update(data)
    $complaint_repository.update(data[:id], data)
  end

  def self.remove(id)
    $complaint_repository.remove(id)
  end

  def self.find_filtered(where_conditions)
    Complaint.where(where_conditions).eager(:status, :citizen, :district).all
  rescue Sequel::Error => e
    puts "Error al buscar quejas con filtros: #{e.message}"
    nil
  end

  def self.find_one_by_ciudadano_id(id)
    Complaint.where(id: id).eager(:status, citizen: [:user], district: [:name]).first
  rescue Sequel::Error => e
    puts "Error al buscar una queja por ciudadano_id: #{e.message}"
    nil
  end

  def self.update_estado(id, data)
    complaint = $complaint_repository.update(id, data)
  rescue Sequel::Error => e
    puts "Error al actualizar el estado de la queja: #{e.message}"
    nil
  end
end
