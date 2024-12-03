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
    complaints = Complaint.where(citizen_id: ciudadano_id)
                          .eager(:status, :subject, { citizen: :user }, :district)
                          .all
  
    # Transformar los resultados
    complaints.map do |complaint|
      {
        id: complaint.id,
        description: complaint.description,
        location_description: complaint.location_description,
        latitude: complaint.latitude,
        longitude: complaint.longitude,
        dateofcreation: complaint.dateofcreation,
        citizen_id: complaint.citizen_id, # Mantener el ID del ciudadano
        subject_name: complaint.subject&.name, # Reemplazar subject_id por subject_name
        status_name: complaint.status&.name,   # Reemplazar status_id por status_name
        district_name: complaint.district&.name # Reemplazar district_id por district_name
      }
    end
  rescue Sequel::Error => e
    puts "Error al buscar quejas por citizen_id: #{e.message}"
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
  
    # Filtrar por subject_ids si se proporciona
    if subject_ids.is_a?(Array) && !subject_ids.empty?
      query = query.where(subject_id: subject_ids)
    end
  
    # Filtrar por district_ids si se proporciona
    if district_ids.is_a?(Array) && !district_ids.empty?
      query = query.where(district_id: district_ids)
    end
  
    # Cargar datos con eager
    resultados = query.eager(:status, :subject, { citizen: :user }, :district).all
  
    # Transformar los resultados
    resultados.map do |complaint|
      {
        id: complaint.id,
        description: complaint.description,
        location_description: complaint.location_description,
        latitude: complaint.latitude,
        longitude: complaint.longitude,
        dateofcreation: complaint.dateofcreation,
        citizen_id: complaint.citizen_id, # Mantener el ID del ciudadano
        subject_name: complaint.subject&.name, # Reemplazar subject_id por subject_name
        status_name: complaint.status&.name,   # Reemplazar status_id por status_name
        district_name: complaint.district&.name # Reemplazar district_id por district_name
      }
    end
  rescue Sequel::Error => e
    puts "Error al buscar quejas: #{e.message}"
    []
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

  def self.find_one_by_complaint_id(complaint_id)
    complaint = Complaint.where(id: complaint_id)
                       .eager(:status, :subject, { citizen: :user }, :district)
                       .first

    # Si no se encuentra la queja, devolver nil
    return nil if complaint.nil?

    # Transformar los datos de la queja
    {
      id: complaint.id,
      description: complaint.description,
      location_description: complaint.location_description,
      latitude: complaint.latitude,
      longitude: complaint.longitude,
      dateofcreation: complaint.dateofcreation,
      citizen_id: complaint.citizen_id, # Mantener el ID del ciudadano
      subject_name: complaint.subject&.name, # Reemplazar subject_id por subject_name
      status_name: complaint.status&.name,   # Reemplazar status_id por status_name
      district_name: complaint.district&.name # Reemplazar district_id por district_name
    }
  rescue Sequel::Error => e
    puts "Error al buscar una queja por complaint_id: #{e.message}"
    nil
  end
end
