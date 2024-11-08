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

  def self.find_all_by_citizen_id(ciudadano_id)
    Complaint.where(citizen_id: ciudadano_id)
             .eager(:status, { citizen: :user }, :district)
             .all
  rescue Sequel::Error => e
    puts "Error al buscar quejas por citizen_id: #{e.message}"
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

  def self.find_filtered(subject_ids, district_ids)
    query = Complaint
    if subject_ids.is_a?(Array) && !subject_ids.empty?
      query = query.where(subject_id: subject_ids)
    end
    if district_ids.is_a?(Array) && !district_ids.empty?
      query = query.where(district_id: district_ids)
    end
    resultados = query.eager(:status, { citizen: :user }, :district).all
  
    #puts "Resultados encontrados: #{resultados.inspect}"
    resultados
  rescue Sequel::Error => e
    puts "Error al buscar quejas: #{e.message}"
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
